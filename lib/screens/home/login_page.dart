import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/cubit/user_cubit.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/screens/global_widgets/loading_indicator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slideAnim;
  TextEditingController emailController =
      TextEditingController(text: "johndoe@example.com");
  TextEditingController passController =
      TextEditingController(text: "password1234");
  bool showPass = false;
  bool fetchMode = false;
  final GlobalKey<State> _boxKey = GlobalKey();
  double boxHeight = 400;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    slideAnim = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      Future.delayed(Duration(seconds: 2)).then((_) {
        messenger.showMaterialBanner(MaterialBanner(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Tip: You can visit the site as admin from social methods menu.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            'DISMISS',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
      backgroundColor: Colors.blue.shade50,
      elevation: 4,
      padding: EdgeInsets.all(16),
    ));
      });
      Future.delayed(Duration(seconds: 7)).then((_) {
        messenger.hideCurrentMaterialBanner();
      });
    });
  }

  void fakeFetch() {
    RenderBox constraints =
        _boxKey.currentContext!.findRenderObject() as RenderBox;
    boxHeight = constraints.size.height;
    setState(() {
      fetchMode = true;
    });
    Future.delayed((Duration(seconds: 3))).then((_){
      setState(() {
        fetchMode = false;
      });
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        Navigator.pushReplacementNamed(context, "home");
      }
    });
    animationController.reverse();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final [width, height] = getScreenSize(context);
    final isSmallScreen = width < 600;
    getThemeMode(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.webp',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),
          SlideTransition(
            position: slideAnim,
            child: Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 40),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Container(
                      key: _boxKey,
                      width: isSmallScreen ? double.infinity : 400,
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hello!',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 24 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'We are really happy to see you again!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: Colors.grey[650]),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                              hintText: 'Username',
                              icon: Icons.person,
                              controller: emailController),
                          const SizedBox(height: 10),
                          _buildTextField(
                              hintText: 'Password',
                              icon: Icons.lock,
                              obscureText: true,
                              controller: passController),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              context.read<UserCubit>().shiftMode(Buyer(orders: []));
                              fakeFetch();
                            },
                            child: Text(
                              'Sign in as Guest',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 16 : 18),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('or sign in with',
                              style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                  icon: Icons.facebook,
                                  iColor: Colors.blue,
                                  context: context,
                                  name: "Facebook"),
                              const SizedBox(width: 10),
                              _buildSocialButton(
                                  icon: Icons.g_mobiledata,
                                  iColor: Colors.green,
                                  context: context,
                                  name: "Google"),
                              const SizedBox(width: 10),
                              _buildSocialButton(
                                  icon: Icons.person,
                                  context: context,
                                  iColor: Colors.indigo,
                                  name: "Admin Account",
                                  ontap: () {
                                    context
                                        .read<UserCubit>()
                                        .shiftMode(Admin());
                                    fakeFetch();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (fetchMode) ...[
                      Container(
                        width: isSmallScreen ? double.infinity : 400,
                        height: boxHeight,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned(
                        top: .9,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: isSmallScreen ? width * .055 : 400 * .1),
                          child: SizedBox(
                              width: (isSmallScreen ? width : 400) * 0.8,
                              child: ColorChangingProgressIndicator()),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required String hintText,
      required IconData icon,
      bool obscureText = false,
      TextEditingController? controller}) {
    return TextField(
      obscureText: obscureText
          ? showPass
              ? false
              : true
          : false,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        suffix: !obscureText
            ? null
            : InkWell(
                onTap: () {
                  setState(() {
                    showPass = !showPass;
                  });
                },
                child: Icon(
                  showPass ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 20,
                )),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      {required IconData icon,
      required String name,
      Color iColor = Colors.grey,
      required BuildContext context,
      VoidCallback? ontap}) {
    return InkWell(
      onTap: ontap ??
          () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Sign In Through $name")));
          },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, size: 30, color: iColor),
      ),
    );
  }
}
