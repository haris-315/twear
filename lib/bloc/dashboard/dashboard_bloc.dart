import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/core/utils/date_calculator.dart';
import 'package:t_wear/models/product_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  List<Product> products = [];

  DashboardBloc() : super(DashboardInitial()) {
    // Event to feed products into the list
    on<FeedProducts>((event, emit) async {
      products =
          event.products.values.fold<List<Product>>([], (previous, item) {
        return [...previous, ...item];
      });
    });

    on<GetDashboardDetails>((event, emit) {
      if (products.isEmpty) {
        emit(DashboardSuccess(dashboardDetails: {
          "totalOrders": 0,
          "totalRevenue": 0.0,
          "avgRating": 0.0,
          "companies": <String>[],
          "products": <DBP>[]
        }));
        return;
      }

      List<String> companies = [];
      int totalOrders =
          products.fold(0, (prev, product) => prev + product.timesSold);

      double totalRevenue = products.fold(
          0,
          (prev, product) =>
              prev +
              ((product.discount) > 0
                  ? (product.price * product.discount / 100) *
                      product.timesSold
                  : (product.price * product.timesSold)));

      double avgRating = products.isNotEmpty
          ? products.fold(0, (total, product) => total + product.avgRating()) /
              products.length
          : 0;

      Product mostSoldProduct = products.first;
      Product productWithMostReview = products.first;
      Product oldestProduct = products.first;
      Product expensiveOfAll = products.first;
      Product latestProduct = products.first;
      Product highlyDiscounted = products.first;
      for (var product in products) {
        companies.add(product.company);

        if (product.timesSold >= mostSoldProduct.timesSold) {
          mostSoldProduct = product;
        }

        if (product.rating.length > productWithMostReview.rating.length) {
          productWithMostReview = product;
        } else if (product.rating.length ==
            productWithMostReview.rating.length) {
          if (calculateDifference(product.postDate) >
              calculateDifference(productWithMostReview.postDate)) {
            productWithMostReview = product;
          }
        }

        if (calculateDifference(product.postDate) >
            calculateDifference(oldestProduct.postDate)) {
          oldestProduct = product;
        }

        if (product.price > expensiveOfAll.price) {
          expensiveOfAll = product;
        } else if (product.price == expensiveOfAll.price) {
          if (calculateDifference(product.postDate) >
              calculateDifference(expensiveOfAll.postDate)) {
            expensiveOfAll = product;
          }
        }

        if (calculateDifference(product.postDate) <
            calculateDifference(latestProduct.postDate)) {
          latestProduct = product;
        }

        if (product.discount != 0) {
          if (product.discount > highlyDiscounted.discount) {
            highlyDiscounted = product;
          }
        }
      }

      emit(DashboardSuccess(dashboardDetails: {
        "totalOrders": totalOrders,
        "totalRevenue": totalRevenue,
        "avgRating": avgRating,
        "companies": <String>[],
        "products": <DBP>[
          DBP(
              name: "Most Sold",
              product: mostSoldProduct,
              color: Colors.redAccent),
          DBP(
              name: "Most Reviewed",
              product: productWithMostReview,
              color: Colors.greenAccent),
          DBP(
              name: "Most Expensive",
              product: expensiveOfAll,
              color: Colors.yellowAccent),
          DBP(
            name: "Oldest",
            product: oldestProduct,
            color: Colors.blueAccent),
          DBP(
              color: Colors.purpleAccent,
              name: "Latest",
              product: latestProduct),
          DBP(color: Colors.deepOrangeAccent, name: "Highly Discounted", product: highlyDiscounted)
        ]
      }));
    });
  }
}

class DBP {
  final String name;
  final Product product;
  final Color color;

  DBP({required this.color, required this.name, required this.product});
}
