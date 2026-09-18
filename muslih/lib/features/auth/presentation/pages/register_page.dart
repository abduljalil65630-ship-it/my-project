import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:muslih/core/constants/app_constants.dart';
import 'package:muslih/core/utils/validators.dart';
import 'package:muslih/features/auth/domain/entities/app_user.dart';
import 'package:muslih/features/auth/presentation/providers/auth_providers.dart';

/// صفحة إنشاء حساب.
///
/// المستخدم يستطيع إنشاء حساب كـ:
/// - عميل
/// - مزود خدمة
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // =========================================================
  // Form
  // =========================================================

  final _formKey = GlobalKey<FormState>();

  // =========================================================
  // Controllers
  // =========================================================

  final _nameCtrl = TextEditingController();

  final _phoneCtrl = TextEditingController();

  final _emailCtrl = TextEditingController();

  final _passwordCtrl = TextEditingController();

  // =========================================================
  // نوع الحساب الافتراضي
  // =========================================================

  UserRole _role = UserRole.customer;

  // =========================================================
  // إظهار / إخفاء كلمة المرور
  // =========================================================

  bool _obscure = true;

  // =========================================================
  // التخلص من Controllers
  // =========================================================

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  // =========================================================
  // تنفيذ التسجيل
  // =========================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref.read(authControllerProvider.notifier).register(
          fullName: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text,
          role: _role,
          email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        );

    if (!mounted) return;

    // بما أن الدالة تعيد void، نتحقق من حالة الـ state إذا لم تكن تحتوي على خطأ
    final authState = ref.read(authControllerProvider);
    if (!authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إنشاء الحساب بنجاح، يمكنك الآن تسجيل الدخول',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      context.go('/login');
    }
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    // مراقبة حالة التسجيل
    final authState = ref.watch(authControllerProvider);

    final isLoading = authState.isLoading;

    // مراقبة الأخطاء
    ref.listen<AsyncValue<AppUser?>>(
      authControllerProvider,
      (previous, next) {
        if (!next.hasError) {
          return;
        }

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إنشاء حساب',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // =================================================
                // اسم التطبيق
                // =================================================

                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // الاسم الكامل
                // =================================================

                TextFormField(
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                  ),
                  validator: (value) {
                    return Validators.required(
                      value,
                      'الاسم',
                    );
                  },
                ),

                const SizedBox(height: 16),

                // =================================================
                // رقم الهاتف
                // =================================================

                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                    prefixIcon: Icon(
                      Icons.phone,
                    ),
                  ),
                  validator: Validators.phone,
                ),

                const SizedBox(height: 16),

                // =================================================
                // البريد الحقيقي - اختياري
                // =================================================

                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني (اختياري)',
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                  validator: Validators.email,
                ),

                const SizedBox(height: 16),

                // =================================================
                // كلمة المرور
                // =================================================

                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (!isLoading) {
                      _submit();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    ),
                  ),
                  validator: Validators.password,
                ),

                const SizedBox(height: 20),

                // =================================================
                // عنوان نوع الحساب
                // =================================================

                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'نوع الحساب',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // اختيار نوع الحساب
                // =================================================

                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<UserRole>(
                    segments: const [
                      ButtonSegment<UserRole>(
                        value: UserRole.customer,
                        label: Text(
                          'عميل',
                        ),
                      ),
                      ButtonSegment<UserRole>(
                        value: UserRole.provider,
                        label: Text(
                          'مزوّد خدمة',
                        ),
                      ),
                    ],
                    selected: {
                      _role,
                    },
                    onSelectionChanged: (selected) {
                      if (selected.isEmpty) {
                        return;
                      }

                      setState(() {
                        _role = selected.first;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // =================================================
                // زر إنشاء الحساب
                // =================================================

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'إنشاء الحساب',
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // الانتقال إلى تسجيل الدخول
                // =================================================

                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.pop();
                        },
                  child: const Text(
                    'لديك حساب؟ تسجيل الدخول',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
