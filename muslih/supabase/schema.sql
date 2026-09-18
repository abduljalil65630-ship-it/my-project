CREATE TABLE public.categories (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    icon TEXT
);

INSERT INTO public.categories
    (id, name, icon)
VALUES
    ('plumbing', 'سباكة', 'plumbing'),
    ('electrical', 'كهرباء', 'electrical'),
    ('carpentry', 'نجارة', 'carpentry'),
    ('painting', 'دهانات', 'painting'),
    ('ac', 'تكييف وتبريد', 'ac'),
    ('cleaning', 'تنظيف', 'cleaning'),
    ('appliances', 'أجهزة منزلية', 'appliances'),
    ('pest', 'مكافحة حشرات', 'pest'),
    ('moving', 'نقل وأثاث', 'moving'),
    ('glass', 'زجاج وألمنيوم', 'glass'),
    ('gardening', 'حدائق وتنسيق', 'gardening'),
    ('locks', 'أقفال وإنقاذ', 'locks'),
    ('roofing', 'أسطح وعزل', 'roofing'),
    ('satellite', 'تغذية وإنترنت', 'satellite'),
    ('general', 'صيانة عامة', 'general');

CREATE TABLE public.profiles (
    id UUID PRIMARY KEY
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    full_name TEXT NOT NULL,

    phone TEXT NOT NULL UNIQUE,

    email TEXT,

    role TEXT NOT NULL DEFAULT 'customer'
        CHECK (role IN ('customer', 'provider')),

    avatar_url TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.providers (
    id UUID PRIMARY KEY
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    full_name TEXT NOT NULL,

    category_id TEXT
        REFERENCES public.categories(id)
        ON DELETE SET NULL,

    bio TEXT,

    city TEXT,

    rating NUMERIC(3,2) NOT NULL DEFAULT 0
        CHECK (rating >= 0 AND rating <= 5),

    review_count INTEGER NOT NULL DEFAULT 0
        CHECK (review_count >= 0),

    completed_jobs INTEGER NOT NULL DEFAULT 0
        CHECK (completed_jobs >= 0),

    hourly_rate NUMERIC(10,2),

    avatar_url TEXT,

    is_verified BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.service_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    customer_id UUID NOT NULL
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    provider_id UUID
        REFERENCES auth.users(id)
        ON DELETE SET NULL,

    category_id TEXT
        REFERENCES public.categories(id)
        ON DELETE SET NULL,

    title TEXT NOT NULL,

    description TEXT,

    city TEXT,

    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (
            status IN (
                'pending',
                'accepted',
                'in_progress',
                'completed',
                'cancelled'
            )
        ),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    request_id UUID NOT NULL
        REFERENCES public.service_requests(id)
        ON DELETE CASCADE,

    customer_id UUID NOT NULL
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    provider_id UUID NOT NULL
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    rating INTEGER NOT NULL
        CHECK (rating >= 1 AND rating <= 5),

    comment TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE (request_id)
);

CREATE INDEX idx_profiles_phone
ON public.profiles(phone);

CREATE INDEX idx_providers_category
ON public.providers(category_id);

CREATE INDEX idx_providers_city
ON public.providers(city);

CREATE INDEX idx_requests_customer
ON public.service_requests(customer_id);

CREATE INDEX idx_requests_provider
ON public.service_requests(provider_id);

CREATE INDEX idx_requests_category
ON public.service_requests(category_id);

CREATE INDEX idx_requests_status
ON public.service_requests(status);
CREATE INDEX idx_reviews_provider
ON public.reviews(provider_id);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_full_name TEXT;
    v_phone TEXT;
    v_role TEXT;
BEGIN

    v_full_name := NULLIF(
        NEW.raw_user_meta_data->>'full_name',
        ''
    );

    v_phone := NULLIF(
        NEW.raw_user_meta_data->>'phone',
        ''
    );

    v_role := COALESCE(
        NULLIF(
            NEW.raw_user_meta_data->>'role',
            ''
        ),
        'customer'
    );

    IF v_full_name IS NULL THEN
        v_full_name := 'مستخدم';
    END IF;

    IF v_phone IS NULL THEN
        RAISE EXCEPTION
            'رقم الهاتف مطلوب لإنشاء الحساب';
    END IF;

    IF v_role NOT IN ('customer', 'provider') THEN
        v_role := 'customer';
    END IF;

    INSERT INTO public.profiles (
        id,
        full_name,
        phone,
        email,
        role
    )
    VALUES (
        NEW.id,
        v_full_name,
        v_phone,
        NEW.email,
        v_role
    );

    -- إذا كان المستخدم مزود خدمة، نقوم بإنشائه في جدول المزودين أيضاً لكي يظهر في الواجهات
    IF v_role = 'provider' THEN
        INSERT INTO public.providers (
            id,
            full_name,
            category_id,
            city,
            rating,
            review_count,
            completed_jobs,
            is_verified
        )
        VALUES (
            NEW.id,
            v_full_name,
            'general', -- تعيينه كـ صيانة عامة/ملك افتراضياً ليظهر في كل الفئات
            'الرياض',  -- مدينة افتراضية ويمكن تعديلها لاحقاً
            0,
            0,
            0,
            false
        );
    END IF;

    RETURN NEW;

END;
$$;

CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.refresh_provider_rating()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_provider_id UUID;
BEGIN

    IF TG_OP = 'DELETE' THEN
        v_provider_id := OLD.provider_id;
    ELSE
        v_provider_id := NEW.provider_id;
    END IF;

    UPDATE public.providers
    SET
        rating = COALESCE(
            (
                SELECT AVG(r.rating)
                FROM public.reviews r
                WHERE r.provider_id = v_provider_id
            ),
            0
        ),

        review_count = (
            SELECT COUNT(*)
            FROM public.reviews r
            WHERE r.provider_id = v_provider_id
        )

    WHERE id = v_provider_id;

    RETURN COALESCE(NEW, OLD);

END;
$$;

CREATE TRIGGER trg_refresh_rating
AFTER INSERT OR UPDATE OR DELETE
ON public.reviews
FOR EACH ROW
EXECUTE FUNCTION public.refresh_provider_rating();

ALTER TABLE public.categories
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.profiles
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.providers
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.service_requests
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.reviews
ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "categories_read"
ON public.categories;

DROP POLICY IF EXISTS "profiles_read"
ON public.profiles;

DROP POLICY IF EXISTS "profiles_insert"
ON public.profiles;

DROP POLICY IF EXISTS "profiles_update"
ON public.profiles;

DROP POLICY IF EXISTS "providers_read"
ON public.providers;

DROP POLICY IF EXISTS "providers_insert"
ON public.providers;

DROP POLICY IF EXISTS "providers_update"
ON public.providers;

DROP POLICY IF EXISTS "providers_delete"
ON public.providers;

DROP POLICY IF EXISTS "requests_read"
ON public.service_requests;

DROP POLICY IF EXISTS "requests_insert"
ON public.service_requests;

DROP POLICY IF EXISTS "requests_update"
ON public.service_requests;

DROP POLICY IF EXISTS "requests_delete"
ON public.service_requests;

DROP POLICY IF EXISTS "reviews_read"
ON public.reviews;

DROP POLICY IF EXISTS "reviews_insert"
ON public.reviews;

CREATE POLICY "categories_read"
ON public.categories
FOR SELECT
USING (true);

CREATE POLICY "profiles_read"
ON public.profiles
FOR SELECT
USING (
    auth.uid() = id
);

CREATE POLICY "profiles_insert"
ON public.profiles
FOR INSERT
WITH CHECK (
    auth.uid() = id
);

CREATE POLICY "profiles_update"
ON public.profiles
FOR UPDATE
USING (
    auth.uid() = id
)
WITH CHECK (
    auth.uid() = id
);

CREATE POLICY "providers_read"
ON public.providers
FOR SELECT
USING (true);

CREATE POLICY "providers_insert"
ON public.providers
FOR INSERT
WITH CHECK (
    auth.uid() = id
);

CREATE POLICY "providers_update"
ON public.providers
FOR UPDATE
USING (
    auth.uid() = id
)
WITH CHECK (
    auth.uid() = id
);
CREATE POLICY "providers_delete"
ON public.providers
FOR DELETE
USING (
    auth.uid() = id
);

CREATE POLICY "requests_read"
ON public.service_requests
FOR SELECT
USING (
    auth.uid() = customer_id
    OR
    auth.uid() = provider_id
);

CREATE POLICY "requests_insert"
ON public.service_requests
FOR INSERT
WITH CHECK (
    auth.uid() = customer_id
);

CREATE POLICY "requests_update"
ON public.service_requests
FOR UPDATE
USING (
    auth.uid() = customer_id
    OR
    auth.uid() = provider_id
)
WITH CHECK (
    auth.uid() = customer_id
    OR
    auth.uid() = provider_id
);

CREATE POLICY "requests_delete"
ON public.service_requests
FOR DELETE
USING (
    auth.uid() = customer_id
);

CREATE POLICY "reviews_read"
ON public.reviews
FOR SELECT
USING (true);

CREATE POLICY "reviews_insert"
ON public.reviews
FOR INSERT
WITH CHECK (
    auth.uid() = customer_id
);