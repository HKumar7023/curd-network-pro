import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import 'dependency_providers.dart';

// Product List Provider
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  return await repository.getProducts();
});

// Product by ID Provider
final productByIdProvider = FutureProvider.family<Product, int>((ref, id) async {
  final repository = ref.read(productRepositoryProvider);
  return await repository.getProductById(id);
});

// Categories Provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  return await repository.getCategories();
});

// Cached Products Provider
final cachedProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  return await repository.getCachedProducts();
});

// Search Products Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productListProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return productsAsync.when(
    data: (products) {
      var filteredProducts = products;
      
      // Filter by category first
      if (selectedCategory != null && selectedCategory.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) {
          return product.category.toLowerCase() == selectedCategory.toLowerCase();
        }).toList();
      }
      
      // Then filter by search query
      if (searchQuery.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) {
          return product.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              product.category.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }
      
      return AsyncValue.data(filteredProducts);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Selected Category Provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final productsByCategoryProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productListProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return productsAsync.when(
    data: (products) {
      if (selectedCategory == null || selectedCategory.isEmpty) {
        return AsyncValue.data(products);
      }
      final filteredProducts = products.where((product) {
        return product.category.toLowerCase() == selectedCategory.toLowerCase();
      }).toList();
      return AsyncValue.data(filteredProducts);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
