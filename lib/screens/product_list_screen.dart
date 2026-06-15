import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';

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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductProvider>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ProductProvider>();

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

                  Expanded(
                    child: ListView.builder(
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
                  ),
                ],
              ),
            ),
    );
  }
}