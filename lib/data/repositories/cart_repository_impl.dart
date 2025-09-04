import 'dart:async';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../models/mappers.dart';

class CartRepositoryImpl implements CartRepository {
  final ProductLocalDataSource localDataSource;
  final StreamController<List<CartItem>> _cartController = StreamController<List<CartItem>>.broadcast();

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addToCart(CartItem cartItem) async {
    try {
      await localDataSource.addToCart(cartItem.toModel());
      _notifyCartUpdated();
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  @override
  Future<void> updateCartItem(CartItem cartItem) async {
    try {
      await localDataSource.updateCartItem(cartItem.toModel());
      _notifyCartUpdated();
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    try {
      await localDataSource.removeFromCart(productId);
      _notifyCartUpdated();
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      return cartItems.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to load cart items: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await localDataSource.clearCart();
      _notifyCartUpdated();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  @override
  Stream<List<CartItem>> watchCartItems() {
    // Initialize with current cart state
    _notifyCartUpdated();
    return _cartController.stream;
  }

  void _notifyCartUpdated() async {
    try {
      final cartItems = await getCartItems();
      _cartController.add(cartItems);
    } catch (e) {
      _cartController.addError(e);
    }
  }

  void dispose() {
    _cartController.close();
  }
}
