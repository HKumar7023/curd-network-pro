import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../../core/constants/app_constants.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> clearProductsCache();
  
  Future<void> addToCart(CartItemModel cartItem);
  Future<void> updateCartItem(CartItemModel cartItem);
  Future<void> removeFromCart(int productId);
  Future<List<CartItemModel>> getCartItems();
  Future<void> clearCart();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  
  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final box = await Hive.openBox<ProductModel>(AppConstants.productsBoxKey);
    await box.clear();
    for (var product in products) {
      await box.put(product.id, product);
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final box = await Hive.openBox<ProductModel>(AppConstants.productsBoxKey);
    return box.values.toList();
  }

  @override
  Future<void> clearProductsCache() async {
    final box = await Hive.openBox<ProductModel>(AppConstants.productsBoxKey);
    await box.clear();
  }

  @override
  Future<void> addToCart(CartItemModel cartItem) async {
    final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
    
    // Check if item already exists in cart
    final existingItem = box.get(cartItem.product.id);
    if (existingItem != null) {
      // Update quantity if item already exists
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + cartItem.quantity,
      );
      await box.put(cartItem.product.id, updatedItem);
    } else {
      await box.put(cartItem.product.id, cartItem);
    }
  }

  @override
  Future<void> updateCartItem(CartItemModel cartItem) async {
    final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
    await box.put(cartItem.product.id, cartItem);
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
    await box.delete(productId);
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
    return box.values.toList();
  }

  @override
  Future<void> clearCart() async {
    final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
    await box.clear();
  }
}
