import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/cubit/user_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/delete_confirm.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/home/widgets/url_identifier.dart';

class BuyerProfilePage extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  BuyerProfilePage({super.key});

  void cancelOrder(Product product, List<Product> orders, BuildContext context,
      CTheme themeMode) async {
    final bool decision = await showConfirmationDialog(context, themeMode,
        msg: "Do you want to cancel the Order.", b1: "No", b2: "Yes");
    if (decision) {
      orders.remove(product);
      // ignore: use_build_context_synchronously
      context.read<UserCubit>().removeFromPending(orders);
    }
  }

  @override
  Widget build(BuildContext context) {
    CTheme themeMode = getThemeMode(context);
    return Scaffold(
      backgroundColor: themeMode.backgroundColor,
      appBar: NavBar(themeMode: themeMode, scrollController: scrollController),
      endDrawer: CustomDrawer(themeMode: themeMode),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/hero.jpg'),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeMode.primTextColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'johndoe@example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: themeMode.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 24.0),
                Card(
                  elevation: 4,
                  color: themeMode.backgroundColor,
                  shadowColor: themeMode.shadowColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildProfileDetailRow(
                            Icons.phone, 'Phone', '+1 234 567 8901', themeMode),
                        const Divider(),
                        _buildProfileDetailRow(Icons.location_on, 'Address',
                            '1234 Elm Street, NY', themeMode),
                        const Divider(),
                        _buildProfileDetailRow(Icons.shopping_cart, 'Orders',
                            '25 orders placed', themeMode),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                if (state is Buyer)
                if (state.orders.isNotEmpty)
                ...[
                  Padding(padding: EdgeInsets.all(12.0)),
                Text("Recent Orders",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis
                ),),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      final product = state.orders[index];
                      final image = product.images.first;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.indigoAccent, width: 1),
                              borderRadius: BorderRadius.zero),
                          color: Colors.pinkAccent[150],
                          shadowColor: Colors.grey.withValues(alpha: 0.2),
                          borderOnForeground: true,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: isValidUrl(image.toString())
                                  ? Image.network(
                                      image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(
                                      image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Ordered On: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: themeMode.borderColor2),
                                    ),
                                    TextSpan(
                                      text: "$index/011/2024    ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "Price: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: themeMode.borderColor2),
                                    ),
                                    TextSpan(
                                      text:
                                          "Rs. ${product.price.toStringAsFixed(2)}    ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "Delivery Charges: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: themeMode.borderColor2),
                                    ),
                                    TextSpan(
                                      text: "Rs. ${product.delivery}    ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: "Status: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: themeMode.borderColor2),
                                    ),
                                    TextSpan(
                                      text: "Pending    ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                cancelOrder(
                                    product, state.orders, context, themeMode);
                              },
                              icon: Icon(
                                Icons.close,
                              ),
                              tooltip: "Cancel Order",
                            ),
                          ),
                        ),
                      );
                    },
                  )]
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileDetailRow(
      IconData icon, String title, String detail, CTheme themeMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: themeMode.primTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                detail,
                style: TextStyle(
                  fontSize: 14,
                  color: themeMode.secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
