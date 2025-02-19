import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/dashboard/dashboard_bloc.dart';
import 'package:t_wear/models/category.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/repos/products_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  ProductsRepo repo = ProductsRepo();

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      var data = await repo.getProducts();
      data.fold((fail) => emit(HomeError(message: fail.message)), (data) {
        emit(HomeSuccess(products: data));
        if (event.context != null) {
          event.context!
              .read<DashboardBloc>()
              .add(FeedProducts(products: data));
        }
      });
    });
    on<GetByCategory>((event, emit) async {
      emit(HomeLoading(byCategory: true));
      var data = await repo.getProductsByCategory(event.category);
      data.fold(
          (fail) => emit(HomeError(message: fail.message)),
          (data) => emit(HomeSuccess(
              products: data,
              isCategorizing: event.category.id == 8 ? false : true)));
    });
    on<GetBySearch>((event, emit) async {
      emit(HomeLoading(byCategory: true));
      var data = await repo.getProductsBySearch(event.query);
      data.fold(
          (fail) => emit(HomeError(message: fail.message)),
          (data) => emit(HomeSuccess(
              products: data,
              isCategorizing:
                  event.query == "" || event.query.isEmpty ? false : true)));
    });
    on<UpdateProduct>((event, emit) async {
      emit(HomeLoading());
       (await repo.updateProduct(event.product)).fold((fail) => emit(HomeError(message: fail.message)), (products) => emit(HomeSuccess(products: products)));
    });
  }
}
