import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/repos/products_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      var data = await getProducts();
      data.fold((fail) => emit(HomeError(message: fail.message)),
          (data) => emit(HomeSuccess(products: data)));
    });
  }
}
