import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<void> addToCart(CartItem cartItem);
  Future<void> updateCartItem(CartItem cartItem);
  Future<void> removeFromCart(int productId);
  Future<List<CartItem>> getCartItems();
  Future<void> clearCart();
  Stream<List<CartItem>> watchCartItems();
}
