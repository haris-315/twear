import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/models/product_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(Buyer(orders: []));

  void addToPending(List<Product> products) {
    emit(Buyer(orders: products));
  }
  void removeFromPending(List<Product> products) {
    emit(Buyer(orders: products));
  }

  void shiftMode(UserState sState) {
    emit(sState);
  }
}
