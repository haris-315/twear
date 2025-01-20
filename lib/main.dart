import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/screens/dashboard/post_product.dart';
import 'package:t_wear/screens/dashboard/profile.dart';
import 'package:t_wear/screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeCubit()),BlocProvider(create: (_) => HomeBloc())],
      child: BlocBuilder<ThemeCubit, CTheme>(
        builder: (context, themeMode) {
          return DefaultTextStyle(
            style: TextStyle(color: themeMode.primTextColor),
            child: AnimatedTheme(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              data: themeMode.getTheme(),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: const Home(),
                routes: {
                  "products": (context) => const ProfilePg(),
                  "home": (context) => const Home(),
                  "postproduct": (context) => const PostProduct()
                },
              ),
            ),
          );
        },
      )));
}
