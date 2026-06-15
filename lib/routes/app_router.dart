import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_list_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final product = state.extra as Product;

          return ProductDetailScreen(
            product: product,
          );
        },
      ),
    ],
  );
}