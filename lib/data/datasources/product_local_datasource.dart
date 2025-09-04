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
    try {
      final box = await Hive.openBox<ProductModel>(AppConstants.productsBoxKey);
      return box.values.toList();
    } catch (e) {
      // If there's a HiveError (like typeId mismatch), clear the corrupted data
      if (e.toString().contains('unknown typeId') || e.toString().contains('HiveError')) {
        await _clearCorruptedProductsData();
        // Return empty list after clearing corrupted data
        return [];
      }
      rethrow;
    }
  }

  Future<void> _clearCorruptedProductsData() async {
    try {
      // Delete the corrupted box file
      await Hive.deleteBoxFromDisk(AppConstants.productsBoxKey);
      // Reopen the box fresh
      final box = await Hive.openBox<ProductModel>(AppConstants.productsBoxKey);
      await box.clear();
    } catch (e) {
      // If we can't clear it, just continue - the app will fetch fresh data from API
      print('Failed to clear corrupted products data: $e');
    }
  }

  @override
  Future<void> clearProductsCache() async {
    final box = await Hive.openBox<ProductModel>(AppConstants.productsBoxKey);
    await box.clear();
  }

  @override
  Future<void> addToCart(CartItemModel cartItem) async {
    try {
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
    } catch (e) {
      // If there's a HiveError, clear corrupted data and retry
      if (e.toString().contains('unknown typeId') || e.toString().contains('HiveError')) {
        await _clearCorruptedCartData();
        // Retry the operation with fresh box
        final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
        await box.put(cartItem.product.id, cartItem);
      } else {
        rethrow;
      }
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
    try {
      final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
      return box.values.toList();
    } catch (e) {
      // If there's a HiveError (like typeId mismatch), clear the corrupted data
      if (e.toString().contains('unknown typeId') || e.toString().contains('HiveError')) {
        await _clearCorruptedCartData();
        // Return empty list after clearing corrupted data
        return [];
      }
      rethrow;
    }
  }

  Future<void> _clearCorruptedCartData() async {
    try {
      // Delete the corrupted box file
      await Hive.deleteBoxFromDisk(AppConstants.cartBoxKey);
      // Reopen the box fresh
      final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
      await box.clear();
    } catch (e) {
      // If we can't clear it, just continue - the app will work without persisted cart data
      print('Failed to clear corrupted cart data: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    final box = await Hive.openBox<CartItemModel>(AppConstants.cartBoxKey);
    await box.clear();
  }
}
