import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../providers/cart_providers.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/professional_cart_item.dart';

class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final cartSummary = ref.watch(cartSummaryProvider);
    final cartActions = ref.read(cartActionsProvider);

        return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'cart'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (!cartSummary.isEmpty)
            TextButton.icon(
              onPressed: () => _showClearCartDialog(context, cartActions),
              icon: Icon(
                Icons.delete_sweep,
                size: 18,
                color: AppTheme.error,
              ),
              label: Text(
                'Clear',
                style: TextStyle(
                  color: AppTheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [

        // Cart Content
        Expanded(
          child: cartItemsAsync.when(
            data: (cartItems) {
              if (cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'no_items_in_cart'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                                             ElevatedButton(
                         onPressed: () {
                           // Navigate to home
                           context.go('/');
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: AppTheme.primaryColor,
                           foregroundColor: Colors.white,
                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8),
                           ),
                         ),
                         child: const Text(
                           'Continue Shopping',
                           style: TextStyle(
                             fontWeight: FontWeight.w600,
                           ),
                         ),
                       ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                                                 return ProfessionalCartItem(
                          cartItem: cartItem,
                          onQuantityChanged: (quantity) async {
                            await cartActions.updateQuantity(
                              cartItem.product,
                              quantity,
                            );
                          },
                          onRemove: () async {
                            await cartActions.removeFromCart(cartItem.product.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('product_removed_from_cart'.tr()),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: AppTheme.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),

                   // Cart Summary
                   if (!cartSummary.isEmpty)
                     Container(
                       decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.surface,
                         border: Border(
                           top: BorderSide(
                             color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                           ),
                         ),
                       ),
                       child: SafeArea(
                         child: Padding(
                           padding: const EdgeInsets.all(AppConstants.defaultPadding),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 'Order Summary',
                                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                               const SizedBox(height: 12),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(
                                     'Items (${cartSummary.totalQuantity})',
                                     style: Theme.of(context).textTheme.bodyMedium,
                                   ),
                                   Text(
                                     '\$${cartSummary.totalPrice.toStringAsFixed(2)}',
                                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                 ],
                               ),
                               const SizedBox(height: 8),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(
                                     'Shipping',
                                     style: Theme.of(context).textTheme.bodyMedium,
                                   ),
                                   Text(
                                     'FREE',
                                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                       color: AppTheme.success,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                                 ],
                               ),
                               const Divider(height: 20),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(
                                     'Total',
                                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                   Text(
                                     '\$${cartSummary.totalPrice.toStringAsFixed(2)}',
                                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                       fontWeight: FontWeight.bold,
                                       color: AppTheme.primaryColor,
                                     ),
                                   ),
                                 ],
                               ),
                               const SizedBox(height: 16),
                               SizedBox(
                                 width: double.infinity,
                                 height: 48,
                                 child: ElevatedButton(
                                   onPressed: () {
                                     _showCheckoutDialog(context);
                                   },
                                   style: ElevatedButton.styleFrom(
                                     backgroundColor: AppTheme.primaryColor,
                                     foregroundColor: Colors.white,
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(8),
                                     ),
                                   ),
                                   child: const Text(
                                     'Proceed to Checkout',
                                     style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),
                ],
              );
            },
            loading: () => ListView.separated(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: 3,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) =>  ListItemShimmer(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'something_went_wrong'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(cartItemsProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text('retry'.tr()),
                  ),
                ],
              ),
            ),
          ),
        )])
        );
    }

  void _showClearCartDialog(BuildContext context, dynamic cartActions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text('Are you sure you want to remove all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await cartActions.clearCart();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cart cleared'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: const Text('This is a demo app. Checkout functionality would be implemented here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


