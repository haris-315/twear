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
      emit(DashboardLoading());
      products = event.products.values.fold<List<Product>>([], (previous, item) {
        return [...previous, ...item];
      });

    });

    // Event to calculate dashboard details
    on<GetDashboardDetails>((event, emit) {
      if (products.isEmpty) {
        emit(DashboardSuccess(dashboardDetails: {
          "totalOrders": 0,
          "totalRevenue": 0.0,
          "avgRating": 0.0,
          "mostSoldProduct": null,
          "productWithMostReview": null,
          "oldestProduct": null,
          "expensiveOfAll": null,
        }));
        return;
      }

      int totalOrders = products.fold(0, (prev, product) => prev + product.timesSold);

      double totalRevenue = products.fold(0, (prev, product) => prev +
          ((product.discount ?? 0) > 0
              ? (product.price * product.discount! / 100) * product.timesSold
              : (product.price * product.timesSold)
          )
      );

      double avgRating = products.isNotEmpty
          ? products.fold(0, (total, product) => total + product.avgRating()) / products.length
          : 0;

      // Finding most sold product
      Product mostSoldProduct = products.first;
      for (var product in products) {
        if (product.timesSold >= mostSoldProduct.timesSold) {
          mostSoldProduct = product;
        }
      }

      // Finding product with most reviews
      Product productWithMostReview = products.first;
      for (var product in products) {
        if (product.rating.length > productWithMostReview.rating.length) {
          productWithMostReview = product;
        } else if (product.rating.length == productWithMostReview.rating.length) {
          if (calculateDifference(product.postDate) > calculateDifference(productWithMostReview.postDate)) {
            productWithMostReview = product;
          }
        }
      }

      // Finding oldest product
      Product oldestProduct = products.first;
      for (var product in products) {
        if (calculateDifference(product.postDate) > calculateDifference(oldestProduct.postDate)) {
          oldestProduct = product;
        }
      }

      // Finding the most expensive product
      Product expensiveOfAll = products.first;
      for (var product in products) {
        if (product.price > expensiveOfAll.price) {
          expensiveOfAll = product;
        } else if (product.price == expensiveOfAll.price) {
          if (calculateDifference(product.postDate) > calculateDifference(expensiveOfAll.postDate)) {
            expensiveOfAll = product;
          }
        }
      }

      // Emit the final dashboard state
      emit(DashboardSuccess(dashboardDetails: {
        "totalOrders": totalOrders,
        "totalRevenue": totalRevenue,
        "avgRating": avgRating,
        "products" : [DBP(name: "Most Sold", product: mostSoldProduct),DBP(name: "Most Reviewed", product: productWithMostReview),DBP(name: "Most Expensive", product: expensiveOfAll),DBP(name: "Oldest", product: oldestProduct)]
      }));
    });
  }
}



class DBP {
  final String name;
  final Product product;

  DBP({required this.name, required this.product});

}