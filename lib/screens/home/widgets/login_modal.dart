// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:t_wear/core/theme/theme.dart';
// import 'package:t_wear/screens/dashboard/widgets/input_decor.dart';

// void loginModal(BuildContext context, CTheme themeMode) {
//   bool showPass = false;
//   // double width = MediaQuery.of(context).size.width;
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Stack(
//         children: [
//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//             child: Container(
//               color: themeMode.backgroundColor!.withValues(alpha: 0.2),
//             ),
//           ),
//           AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//             backgroundColor: themeMode.backgroundColor,
//             content: StatefulBuilder(
//               builder: (context, setStateDialog) {
//                 return SizedBox(
//                   width: double.infinity * 7.2,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 20),
//                       Text(
//                         "Login",
//                         style: TextStyle(
//                             color: themeMode.primTextColor,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: 320,
//                         child: TextField(
//                           decoration: inputDecor(
//                             ht: "Email",
//                             hit: "Email",
//                             icon: Icons.email,
//                             themeMode: themeMode,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       SizedBox(
//                         width: 320,
//                         child: TextField(
//                           obscureText: !showPass,
//                           obscuringCharacter: "*",
//                           decoration: InputDecoration(
//                             labelText: "Password",
//                             suffixIcon: IconButton(
//                               onPressed: () {
//                                 setStateDialog(() {
//                                   showPass = !showPass;
//                                 });
//                               },
//                               icon: Icon(showPass
//                                   ? Icons.visibility
//                                   : Icons.visibility_off_outlined),
//                             ),
//                             prefixIcon:
//                                 Icon(Icons.lock, color: themeMode.iconColor),
//                             contentPadding: const EdgeInsets.all(8),
//                             helperStyle:
//                                 TextStyle(color: themeMode.primTextColor),
//                             labelStyle: TextStyle(
//                                 color: themeMode.primTextColor, fontSize: 12),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 2,
//                                   color: themeMode.borderColor ?? Colors.red),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 2,
//                                   color: themeMode.borderColor2 ?? Colors.red),
//                             ),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   width: 2,
//                                   color: themeMode.borderColor ?? Colors.red),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       ElevatedButton(
//                         onPressed: () {},
//                         style: ButtonStyle(
//                             backgroundColor: WidgetStateColor.resolveWith(
//                                 (_) => themeMode.borderColor2 ?? Colors.red)),
//                         child: Text("Log In"),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//             actions: [],
//           ),
//         ],
//       );
//     },
//   );
// }
