import '../models/product_model.dart';
import '../../core/network/api_service.dart';
import '../../core/constants/api_constants.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiService.get(ApiConstants.productsEndpoint);
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiService.get('${ApiConstants.productsEndpoint}/$id');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await apiService.get(ApiConstants.categoriesEndpoint);
      final List<dynamic> data = response.data;
      return data.cast<String>();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
