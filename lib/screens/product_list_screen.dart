import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/price_range_filter_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState
    extends State<ProductListScreen> {
  final ScrollController _scrollController =
      ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      if (mounted){
        context.read<ProductProvider>().initialize();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted && _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductProvider>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ProductProvider>();

    // Check for error state first
    if (provider.errorMessage != null && provider.errorMessage!.isNotEmpty && provider.products.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: ErrorStateWidget(
          message: provider.errorMessage!,
          onRetry: () {
            provider.initialize();
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SearchBarWidget(
                    onChanged:
                        provider.searchProducts,
                  ),

                  const SizedBox(height: 12),

                  CategoryFilterWidget(
                    categories:
                        provider.categories,
                    selectedCategory:
                        provider.selectedCategory,
                    onChanged: (value) {
                      if (value != null) {
                        provider
                            .filterByCategory(
                                value);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  PriceRangeFilterWidget(
                    minPrice: 0,
                    maxPrice: 2000,
                    currentMin: provider.minPrice,
                    currentMax: provider.maxPrice,
                    onChanged: (min, max) {
                      provider.filterByPriceRange(min, max);
                    },
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: provider.products.isEmpty
                        ? EmptyStateWidget(
                            title: 'No Products Found',
                            subtitle: 'Try adjusting your search or filters',
                          )
                        : Stack(
                            children: [
                              ListView.builder(
                                controller:
                                    _scrollController,
                                itemCount:
                                    provider.products.length,
                                itemBuilder:
                                    (context, index) {
                                  final product =
                                      provider.products[
                                          index];

                                  return ProductCard(
                                    product: product,
                                    onTap: () {
                                      context.push(
                                        '/details',
                                        extra: product,
                                      );
                                    },
                                  );
                                },
                              ),
                              // Pagination loading indicator
                              if (provider.isLoadingMore)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: LinearProgressIndicator(
                                    minHeight: 2,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}