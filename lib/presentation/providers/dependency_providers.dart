import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_service.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/cart_repository.dart';

// Network
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Data Sources
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl(
    apiService: ref.read(apiServiceProvider),
  );
});

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  return ProductLocalDataSourceImpl();
});

// Repositories
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    remoteDataSource: ref.read(productRemoteDataSourceProvider),
    localDataSource: ref.read(productLocalDataSourceProvider),
  );
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    localDataSource: ref.read(productLocalDataSourceProvider),
  );
});
