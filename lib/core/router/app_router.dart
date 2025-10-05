import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sub/features/subscriptions/screens/home_screen.dart';
import 'package:sub/features/subscriptions/screens/add_subscription_screen.dart';
import 'package:sub/features/subscriptions/screens/edit_subscription_screen.dart';
import 'package:sub/features/subscriptions/screens/subscription_detail_screen.dart';

/// App router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Shell route with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          // Home (Subscriptions) Route
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),

          // Analytics Route
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _lazyLoadScreen(() => const AnalyticsScreen()),
            ),
          ),

          // Payments Route
          GoRoute(
            path: '/payments',
            name: 'payments',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _lazyLoadScreen(() => const PaymentsScreen()),
            ),
          ),

          // Settings Route
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              child: _lazyLoadScreen(() => const SettingsScreen()),
            ),
          ),
        ],
      ),

      // Add Subscription Route
      GoRoute(
        path: '/subscription/add',
        name: 'addSubscription',
        builder: (context, state) => const AddSubscriptionScreen(),
      ),

      // Edit Subscription Route
      GoRoute(
        path: '/subscription/:id/edit',
        name: 'editSubscription',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditSubscriptionScreen(id: id);
        },
      ),

      // Subscription Detail Route
      GoRoute(
        path: '/subscription/:id',
        name: 'subscriptionDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SubscriptionDetailScreen(id: id);
        },
      ),

      // Add Payment Method Route
      GoRoute(
        path: '/payment-method/add',
        name: 'addPaymentMethod',
        builder: (context, state) =>
            _lazyLoadScreen(() => const AddPaymentMethodScreen()),
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );

  /// Lazy load screen widget
  static Widget _lazyLoadScreen(Widget Function() builder) {
    return FutureBuilder(
      future: Future.delayed(Duration.zero, builder),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data as Widget;
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

/// Scaffold with bottom navigation bar
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/analytics')) return 1;
    if (location.startsWith('/payments')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('analytics');
        break;
      case 2:
        context.goNamed('payments');
        break;
      case 3:
        context.goNamed('settings');
        break;
    }
  }
}

// Placeholder screens (to be implemented)
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: const Center(child: Text('Analytics Screen')),
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: const Center(child: Text('Payments Screen')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('addPaymentMethod'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class AddSubscriptionScreen extends StatelessWidget {
  const AddSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Subscription')),
      body: const Center(child: Text('Add Subscription Form')),
    );
  }
}

class EditSubscriptionScreen extends StatelessWidget {
  final String id;
  const EditSubscriptionScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Subscription')),
      body: Center(child: Text('Edit Subscription: $id')),
    );
  }
}

class SubscriptionDetailScreen extends StatelessWidget {
  final String id;
  const SubscriptionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Details')),
      body: Center(child: Text('Subscription Details: $id')),
    );
  }
}

class AddPaymentMethodScreen extends StatelessWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment Method')),
      body: const Center(child: Text('Add Payment Method Form')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Page not found')),
    );
  }
}
