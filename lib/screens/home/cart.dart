import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_wear/bloc/cubit/user_cubit.dart';
import 'package:t_wear/bloc/cubit/cart_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_admin_stat.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/kpi.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/home/widgets/checkout.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _wrapKey = GlobalKey();
  List<Product> cartedProducts = [];
  late double totalPrice;
  late double totalOriginalPrice;
  late double totalDiscount;


  void checkOut() async {
    await showCheckoutBottomSheet(context);
    WidgetsBinding.instance.addPostFrameCallback((_){
       UserState adminState = context.read<UserCubit>().state;
    if (adminState is Buyer) {
      context.read<UserCubit>().addToPending([...adminState.orders,...cartedProducts]);
    }});
  }

  @override
  Widget build(BuildContext context) {
    bool admin = isAdmin(context);
    final CTheme themeMode = getThemeMode(context);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartSuccess) {
          cartedProducts = state.cartedProdcuts;

          totalOriginalPrice = cartedProducts == []
              ? 0
              : cartedProducts.fold(0, (sum, item) => sum + item.price);

          totalPrice = cartedProducts.isEmpty
              ? 0
              : cartedProducts.fold(
                  0,
                  (sum, item) => (item.discount) > 0
                      ? sum + ((item.discount * item.price) / 100)
                      : sum + item.price);
        } else {
          totalOriginalPrice = 0;
          totalPrice = 0;
        }

        return state is CartSuccess
            ? Scaffold(
                backgroundColor: themeMode.backgroundColor,
                appBar: NavBar(
                    themeMode: themeMode, scrollController: _scrollController),
                endDrawer: CustomDrawer(themeMode: themeMode),
                body: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            themeMode.backgroundColor!.withValues(alpha: 0.8),
                            themeMode.backgroundColor!.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),

                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              key: _wrapKey,
                              spacing: 10,
                              runSpacing: 20,
                              children: [
                                buildKpiCard(
                                  themeMode: themeMode,
                                  icon: Icons.shopping_basket,
                                  title: "Total Items",
                                  value: cartedProducts.length.toString(),
                                  color: Colors.blueAccent,
                                ),
                                buildKpiCard(
                                  themeMode: themeMode,
                                  icon: Icons.attach_money,
                                  title: "Discounted Price",
                                  value: totalPrice.toStringAsFixed(2),
                                  color: Colors.greenAccent,
                                ),
                                buildKpiCard(
                                    themeMode: themeMode,
                                    icon: Icons.percent_outlined,
                                    title: "Total Discount",
                                    value:
                                        "${(((totalOriginalPrice - totalPrice) / totalOriginalPrice) * 100).toStringAsFixed(1)}%",
                                    color: Colors.yellowAccent),
                                buildKpiCard(
                                    themeMode: themeMode,
                                    icon: Icons.attach_money,
                                    title: "Actual Price",
                                    value: "$totalOriginalPrice",
                                    color: Colors.redAccent),
                              ],
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cartedProducts.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) => _buildCartItem(
                                context,
                                cartedProducts[index],
                                index,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeMode.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24)),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeMode.secondaryTextColor,
                                  ),
                                ),
                                Text(
                                  '\$${totalOriginalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: themeMode.primTextColor,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.red,
                                      decorationThickness: 1.6),
                                ),
                                Text(
                                  '\$${totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: themeMode.primTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Colors.white),
                              label: const Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                disabledBackgroundColor: Colors.blueAccent[200],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: admin
                                  ? () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Admins Cannot Buy From Their Store.")));
                                    }
                                  : () {
                                      if (state.cartedProdcuts.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
 
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            action: SnackBarAction(
                                                label: "Home",
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                }),
                                            content: Text(
                                              "Your cart is empty. Please add some products from the home page.",
                                            ),
                                          ),
                                        );
                                      } else {
                                        checkOut();
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildCartItem(BuildContext context, Product product, int index) {
    return Dismissible(
      key: Key(product.name.substring(0, product.name.length - 4) +
          product.targetAge),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_forever, color: Colors.red, size: 32),
      ),
      onDismissed: (direction) {
        context.read<CartCubit>().removeFromCart(product, cartedProducts);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} removed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                context.read<CartCubit>().addToCart(product, cartedProducts);
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.images.first,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.category.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                      label: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
