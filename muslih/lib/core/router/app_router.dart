import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:muslih/features/auth/presentation/pages/login_page.dart';
import 'package:muslih/features/auth/presentation/pages/register_page.dart';
import 'package:muslih/features/market/presentation/pages/categories_page.dart';
import 'package:muslih/features/market/presentation/pages/providers_list_page.dart';
import 'package:muslih/features/market/presentation/pages/provider_detail_page.dart';
import 'package:muslih/features/market/presentation/pages/provider_services_page.dart';
import 'package:muslih/features/market/presentation/pages/request_page.dart';
import 'package:muslih/features/market/presentation/pages/chat_page.dart';
import 'package:muslih/features/market/presentation/pages/my_requests_page.dart';
import 'package:muslih/features/market/presentation/pages/provider_orders_page.dart';
import 'package:muslih/features/profile/presentation/pages/profile_page.dart';
import 'package:muslih/features/splash/presentation/pages/splash_page.dart';

/// ===============================================================
/// مراقبة تغيّر حالة تسجيل الدخول في Supabase
/// ===============================================================

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen(
      (_) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// ===============================================================
/// Router
/// ===============================================================

final routerProvider = Provider<GoRouter>((ref) {
  final supabase = Supabase.instance.client;

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(
      supabase.auth.onAuthStateChange,
    ),
    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final bool loggedIn = session != null;
      final String location = state.matchedLocation;
      final bool isAuthPage = location == '/login' || location == '/register';
      final bool isSplashPage = location == '/splash';

      if (!loggedIn) {
        if (isSplashPage) return null;
        if (isAuthPage) return null;
        return '/login';
      }

      if (loggedIn) {
        if (isAuthPage || isSplashPage) return '/';
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const CategoriesPage(),
      ),
      GoRoute(
        path: '/provider-services',
        builder: (context, state) => const ProviderServicesPage(),
      ),
      GoRoute(
        path: '/providers-list/:categoryId',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId'];
          if (categoryId == null || categoryId.isEmpty) {
            return const CategoriesPage();
          }
          return ProvidersListPage(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/provider/:id',
        builder: (context, state) {
          final providerId = state.pathParameters['id'];
          if (providerId == null || providerId.isEmpty) {
            return const CategoriesPage();
          }
          return ProviderDetailPage(providerId: providerId);
        },
      ),
      GoRoute(
        path: '/request/:providerId',
        builder: (context, state) {
          final providerId = state.pathParameters['providerId'];
          if (providerId == null || providerId.isEmpty) {
            return const CategoriesPage();
          }
          return RequestPage(providerId: providerId);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/my-requests',
        builder: (context, state) => const MyRequestsPage(),
      ),
      GoRoute(
        path: '/provider-orders',
        builder: (context, state) => const ProviderOrdersPage(),
      ),
      GoRoute(
        path: '/chat/:requestId/:name',
        builder: (context, state) {
          final requestId = state.pathParameters['requestId']!;
          final name = state.pathParameters['name']!;
          return ChatPage(requestId: requestId, otherPartyName: name);
        },
      ),
    ],
  );
});
