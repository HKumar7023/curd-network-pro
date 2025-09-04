import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import 'dependency_providers.dart';

// Cart Items Provider
final cartItemsProvider = StreamProvider<List<CartItem>>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return repository.watchCartItems();
});

// Cart Actions Provider
final cartActionsProvider = Provider<CartActions>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return CartActions(repository);
});

// Cart Summary Provider
final cartSummaryProvider = Provider<CartSummary>((ref) {
  final cartItemsAsync = ref.watch(cartItemsProvider);
  
  return cartItemsAsync.when(
    data: (cartItems) {
      final totalQuantity = cartItems.fold<int>(
        0, 
        (sum, item) => sum + item.quantity,
      );
      
      final totalPrice = cartItems.fold<double>(
        0.0, 
        (sum, item) => sum + item.totalPrice,
      );
      
      return CartSummary(
        itemCount: cartItems.length,
        totalQuantity: totalQuantity,
        totalPrice: totalPrice,
        isEmpty: cartItems.isEmpty,
      );
    },
    loading: () => const CartSummary(
      itemCount: 0,
      totalQuantity: 0,
      totalPrice: 0.0,
      isEmpty: true,
    ),
    error: (_, __) => const CartSummary(
      itemCount: 0,
      totalQuantity: 0,
      totalPrice: 0.0,
      isEmpty: true,
    ),
  );
});

// Check if product is in cart
final isInCartProvider = Provider.family<bool, int>((ref, productId) {
  final cartItemsAsync = ref.watch(cartItemsProvider);
  
  return cartItemsAsync.when(
    data: (cartItems) => cartItems.any((item) => item.product.id == productId),
    loading: () => false,
    error: (_, __) => false,
  );
});

// Get cart item by product ID
final cartItemByProductProvider = Provider.family<CartItem?, int>((ref, productId) {
  final cartItemsAsync = ref.watch(cartItemsProvider);
  
  return cartItemsAsync.when(
    data: (cartItems) {
      try {
        return cartItems.firstWhere((item) => item.product.id == productId);
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

class CartActions {
  final dynamic _repository;

  CartActions(this._repository);

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final cartItem = CartItem(product: product, quantity: quantity);
    await _repository.addToCart(cartItem);
  }

  Future<void> updateQuantity(Product product, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(product.id);
    } else {
      final cartItem = CartItem(product: product, quantity: quantity);
      await _repository.updateCartItem(cartItem);
    }
  }

  Future<void> removeFromCart(int productId) async {
    await _repository.removeFromCart(productId);
  }

  Future<void> clearCart() async {
    await _repository.clearCart();
  }
}

class CartSummary {
  final int itemCount;
  final int totalQuantity;
  final double totalPrice;
  final bool isEmpty;

  const CartSummary({
    required this.itemCount,
    required this.totalQuantity,
    required this.totalPrice,
    required this.isEmpty,
  });
}
