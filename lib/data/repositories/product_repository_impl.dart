import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_local_datasource.dart';
import '../models/mappers.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      // Cache products locally
      await localDataSource.cacheProducts(products);
      return products.map((model) => model.toEntity()).toList();
    } catch (e) {
      // If network fails, try to get cached products
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        return cachedProducts.map((model) => model.toEntity()).toList();
      } catch (cacheError) {
        throw Exception('Failed to load products: $e');
      }
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return product.toEntity();
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  @override
  Future<List<Product>> getCachedProducts() async {
    try {
      final cachedProducts = await localDataSource.getCachedProducts();
      return cachedProducts.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to load cached products: $e');
    }
  }
}
