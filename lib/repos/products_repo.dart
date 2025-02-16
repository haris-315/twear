import 'package:flutter/foundation.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:fpdart/fpdart.dart';
import 'package:t_wear/models/category.dart' as cat;
import 'package:t_wear/models/failure.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/repos/local_data_sources/product_source.dart';
import 'package:t_wear/screens/home/widgets/category.dart';

class ProductsRepo {
  late List<Product> products;
  Map<dynamic, List<Product>> categorizedProducts = {"trending": <Product>[]};

  ProductsRepo() {
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    products = await compute(_parseProducts, productsMaps);
    productsMaps.clear();
  }

  static List<Product> _parseProducts(List<Map<String, dynamic>> productsMaps) {
    return productsMaps.map((element) {
      element['details'] = Delta.fromJson(element['details']);
      return Product.fromMap(element);
    }).toList();
  }

  Future<Either<Failure, Map<dynamic, List<Product>>>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      for (var category in categories) {
        List<Product> trending =
            products.where((product) => product.avgRating() == 5).toList();
        categorizedProducts['trending'] = trending;

        List<Product> tempProductsList = products
            .where((product) => product.category.id == category.id)
            .toList();
        if (tempProductsList.isNotEmpty) {
          categorizedProducts[category.name] = tempProductsList;
        }
      }

      return right(categorizedProducts);
    } catch (e) {
      return left(Failure(message: e.toString(), st: StackTrace.current));
    }
  }

  Future<Either<Failure, Map<dynamic, List<Product>>>> getProductsByCategory(
      cat.Category category) async {
    if (category.id == 8) {
      return await getProducts();
    }
    await Future.delayed(const Duration(seconds: 1));
    try {
      categorizedProducts.removeWhere((key, value) => key != "trending");

      categorizedProducts[category.name] = products
          .where((product) => product.category.id == category.id)
          .toList();
      return right(categorizedProducts);
    } catch (e) {
      return left(Failure(message: e.toString(), st: StackTrace.current));
    }
  }

  Future<Either<Failure, Map<dynamic, List<Product>>>> getProductsBySearch(
      String query) async {
    if (query.isEmpty || query == "") {
      categorizedProducts.removeWhere((key, value) => key != "trending");
      return await getProducts();
    }
    await Future.delayed(const Duration(seconds: 1));
    try {
      categorizedProducts.removeWhere((key, value) => key != "trending");

      List<Product> searchedProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              deltaToPlainText(product.details)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
      categorizedProducts[query] = searchedProducts;
      return right(categorizedProducts);
    } catch (e) {
      return left(Failure(message: e.toString(), st: StackTrace.current));
    }
  }

  String deltaToPlainText(Delta delta) {
    return delta.toList().map((op) => op.data.toString()).join();
  }
}

