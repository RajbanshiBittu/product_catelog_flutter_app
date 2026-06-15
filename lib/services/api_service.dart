import 'package:dio/dio.dart';
import '../models/product.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Product>> fetchProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      final List products = response.data['products'];

      return products
          .map((product) => Product.fromJson(product))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response =
          await _dio.get('/products/category-list');

      return List<String>.from(response.data);
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }
}