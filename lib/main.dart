import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/cubit/user_cubit.dart';
import 'package:t_wear/bloc/cubit/cart_cubit.dart';
import 'package:t_wear/bloc/dashboard/dashboard_bloc.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/screens/dashboard/dashboard.dart';
import 'package:t_wear/screens/dashboard/post_product.dart';
import 'package:t_wear/screens/dashboard/profile.dart';
import 'package:t_wear/screens/home/cart.dart';
import 'package:t_wear/screens/home/home.dart';
import 'package:t_wear/screens/home/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => UserCubit())
      ],
      child: BlocBuilder<ThemeCubit, CTheme>(
        builder: (context, themeMode) {
              precacheImage(const AssetImage('assets/images/bg.webp'), context);

          return DefaultTextStyle(
            style: TextStyle(color: themeMode.primTextColor),
            child: AnimatedTheme(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              data: themeMode.getTheme(),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                
                home: LoginPage(),
                routes: {
                  "dashboard": (context) => const DashBoardPg(),
                  "home": (context) => Home(),
                  "postproduct": (context) => const PostProduct(),
                  "cart": (context) => const Cart(),
                  "profile" : (context) => BuyerProfilePage()
                },
              ),
            ),
          );
        },
      )));
}
