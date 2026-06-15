import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  final List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;

  String? _errorMessage;

  int _skip = 0;
  final int _limit = 10;

  bool _hasMore = true;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  double _minPrice = 0;
  double _maxPrice = 1000;

  // Getters

  List<Product> get products => _filteredProducts;

  double get minPrice => _minPrice;

  double get maxPrice => _maxPrice;

  List<String> get categories => _categories;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMore => _hasMore;

  String? get errorMessage => _errorMessage;

  String get selectedCategory => _selectedCategory;

  // ==========================
  // INITIAL LOAD
  // ==========================

  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await Future.wait([
        fetchProducts(),
        fetchCategories(),
      ]);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ==========================
  // FETCH PRODUCTS
  // ==========================

  Future<void> fetchProducts() async {
    try {
      final newProducts = await _apiService.fetchProducts(
        limit: _limit,
        skip: _skip,
      );

      if (newProducts.length < _limit) {
        _hasMore = false;
      }

      _products.addAll(newProducts);

      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // ==========================
  // FETCH CATEGORIES
  // ==========================

  Future<void> fetchCategories() async {
    try {
      final result = await _apiService.fetchCategories();

      _categories = [
        'All',
        ...result,
      ];
    } catch (e) {
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // ==========================
  // LOAD MORE
  // ==========================

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    _isLoadingMore = true;

    notifyListeners();

    _skip += _limit;

    await fetchProducts();

    _isLoadingMore = false;

    notifyListeners();
  }

  // ==========================
  // SEARCH
  // ==========================

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();

    _applyFilters();
  }

  // ==========================
  // CATEGORY FILTER
  // ==========================

  void filterByCategory(String category) {
    _selectedCategory = category;

    _applyFilters();
  }

  // ==========================
  // PRICE RANGE FILTER
  // ==========================

  /// Filter products by price range (inclusive)
  void filterByPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  // ==========================
  // APPLY FILTERS
  // ==========================

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch =
          product.title.toLowerCase().contains(_searchQuery);

      final matchesCategory =
          _selectedCategory == 'All' ||
          product.category == _selectedCategory;

      // Price range check (inclusive)
      final matchesPrice = product.price >= _minPrice && 
                          product.price <= _maxPrice;

      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();

    notifyListeners();
  }
}