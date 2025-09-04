class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/products/categories';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
