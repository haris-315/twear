import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/cubit/admin_cubit.dart';

bool isAdmin(BuildContext context) {
  return context.watch<AdminCubit>().state is IsAdmin;
}
