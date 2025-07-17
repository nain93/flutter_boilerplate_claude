import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/counter/presentation/pages/counter_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
import '../navigation/bottom_navigation_shell.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';

enum AppRoutes {
  home,
  counter,
  users,
  profile;

  /// Convert to `lower-snake-case` format.
  String get path {
    var exp = RegExp(r'(?<=[a-z])[A-Z]');
    var result = name
        .replaceAllMapped(exp, (m) => '-${m.group(0)}')
        .toLowerCase();
    return result;
  }

  /// Convert to `lower-snake-case` format with `/`.
  String get fullPath {
    var exp = RegExp(r'(?<=[a-z])[A-Z]');
    var result = name
        .replaceAllMapped(exp, (m) => '-${m.group(0)}')
        .toLowerCase();
    return '/$result';
  }
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home.fullPath,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BottomNavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home.fullPath,
            name: AppRoutes.home.path,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.counter.fullPath,
            name: AppRoutes.counter.path,
            builder: (context, state) => const CounterPage(),
          ),
          GoRoute(
            path: AppRoutes.users.fullPath,
            name: AppRoutes.users.path,
            builder: (context, state) => const UsersPage(),
          ),
          GoRoute(
            path: AppRoutes.profile.fullPath,
            name: AppRoutes.profile.path,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
