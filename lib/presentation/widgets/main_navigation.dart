import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/themes/app_theme.dart';
import '../providers/cart_providers.dart';

class MainNavigation extends ConsumerWidget {
  final Widget child;

  const MainNavigation({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartSummary = ref.watch(cartSummaryProvider);
    
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: _getSelectedIndex(context),
            onDestinationSelected: (index) => _onDestinationSelected(context, index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 80,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: 'home'.tr(),
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: cartSummary.totalQuantity > 0,
                  label: Text('${cartSummary.totalQuantity}'),
                  backgroundColor: AppTheme.error,
                  textColor: Colors.white,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: cartSummary.totalQuantity > 0,
                  label: Text('${cartSummary.totalQuantity}'),
                  backgroundColor: AppTheme.error,
                  textColor: Colors.white,
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'cart'.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: 'settings'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    
    if (location.startsWith('/cart')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0; // home
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/cart');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }
}
