import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:t_wear/bloc/cubit/cart_cubit.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_admin_stat.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/delete_confirm.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/home/widgets/url_identifier.dart';

// ignore: must_be_immutable
class ProductDetailPage extends StatefulWidget {
  Product product;

  ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  int _currentImageIndex = 0;
  int rating = -1;
  List<Product> cartedProducts = [];
  ScrollController scrollController = ScrollController();
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  double _discountedPrice(Product uProduct) => uProduct.discount != 0
      ? uProduct.price -
          (uProduct.price * (uProduct.discount / 100))
      : uProduct.price;

  quill.QuillController _quillController(Product uProduct) => quill.QuillController(
        document: quill.Document.fromDelta(uProduct.details),
        readOnly: true,
        selection: const TextSelection.collapsed(offset: 0),
      );

  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  late Animation<double> _menuAnimation;
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));

    _menuAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));
  }


  void _updateProduct() {
    Navigator.pushReplacementNamed(context, "postproduct",
                              arguments: widget.product);
    
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CTheme theme = getThemeMode(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final [width, height] = getScreenSize(context);
    final bool admin = isAdmin(context);

    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
      if (state is CartSuccess) {
        cartedProducts = state.cartedProdcuts;
      }
      final bool isCarted = cartedProducts.contains(widget.product);

      return uiBuilder(theme, width, textTheme, admin, isCarted,widget.product);
    });
  }

  Scaffold uiBuilder(CTheme theme, width, TextTheme textTheme, bool admin, bool isCarted,Product uProduct) {
    return Scaffold(
      key: key,
      backgroundColor: theme.backgroundColor,
      appBar: NavBar(
        themeMode: theme,
        scrollController: scrollController,
      ),
      endDrawer: CustomDrawer(themeMode: theme),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(theme, width,uProduct),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    uProduct.name,
                    style: TextStyle(
                        color: theme.primTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Manufacturer: ${uProduct.company}",
                    style: TextStyle(
                        color: theme.secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Rs. ${_discountedPrice(uProduct).toStringAsFixed(2)}',
                          style: TextStyle(
                              color: theme.primTextColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      if (uProduct.discount != 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Rs. ${uProduct.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: theme.secondaryTextColor,
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    uProduct.stock > 0
                        ? 'In Stock (${uProduct.stock})'
                        : 'Out of Stock',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: uProduct.stock > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailsSection(theme, textTheme, _quillController(uProduct)),
                  const SizedBox(height: 20),
                  _buildRatingSection(theme,admin,uProduct.avgRating()),
                  const SizedBox(height: 20),
                  _buildProductInfoSection(theme, width,uProduct),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (admin)
                Transform.translate(
                  offset: Offset(0, -_menuAnimation.value * 60),
                  child: Opacity(
                    opacity: _fabAnimation.value,
                    child: FloatingActionButton(
                      heroTag: uProduct.postDate,
                      onPressed: () async {
                        bool delete =
                            await showConfirmationDialog(context, theme);
                        if (delete) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully deleted ${uProduct.name}")));
                            context
                                .read<HomeBloc>()
                                .add(DeleteProduct(product: uProduct));
                          });
                        }
                      },
                      backgroundColor: theme.buttonColor,
                      child: Icon(Icons.delete),
                    ),
                  ),
                ),
              SizedBox(
                height: 4,
              ),
              if (admin)
                Transform.translate(
                  offset: Offset(0, -_menuAnimation.value * 60),
                  child: Opacity(
                    opacity: _fabAnimation.value,
                    child: FloatingActionButton(
                      heroTag: uProduct.discount,
                      onPressed: () {
                        _updateProduct();
                      },
                      backgroundColor: theme.buttonColor,
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              if (!admin)
                Transform.translate(
                  offset: Offset(0, -_menuAnimation.value * 60),
                  child: Opacity(
                    opacity: _fabAnimation.value,
                    child: FloatingActionButton.extended(
                      heroTag: uProduct.id,
                      onPressed: () {
                        if (isCarted) {
                          Navigator.pushReplacementNamed(context, "cart");
                        } else {
                          context
                              .read<CartCubit>()
                              .addToCart(uProduct, cartedProducts);
                        }
                      },
                      icon: Icon(Icons.shopping_cart, color: theme.iconColor),
                      label: Text(isCarted ? 'Go to Cart' : 'Add to Cart',
                          style: TextStyle(color: theme.primTextColor)),
                      backgroundColor: theme.buttonColor,
                    ),
                  ),
                ),
              FloatingActionButton(
                heroTag: uProduct.delivery,
                onPressed: () {
                  if (_fabController.isCompleted) {
                    _fabController.reverse();
                  } else {
                    _fabController.forward();
                  }
                },
                backgroundColor: theme.buttonColor,
                child: AnimatedIcon(
                  icon: AnimatedIcons.menu_arrow,
                  progress: _fabAnimation,
                  color: theme.iconColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageCarousel(CTheme theme, double width, Product uProduct) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: width <= 700
                ? width * .75
                : width <= 1000
                    ? width * .45
                    : width * .32,
            autoPlay: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _currentImageIndex = index);
            },
          ),
          items: uProduct.images.map((url) {
            return GestureDetector(
              onTap: () {
                // Navigator.push(MaterialPageRoute())
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: !isValidUrl(url.toString())
                        ? MemoryImage(url)
                        : NetworkImage(url),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (_currentImageIndex > 0) {
                    _carouselController.previousPage();
                  } else {
                    _carouselController
                        .jumpToPage(uProduct.images.length - 1);
                  }
                },
                icon: Icon(Icons.arrow_left_outlined, color: theme.iconColor),
              ),
              _buildDotsIndicator(uProduct),
              IconButton(
                onPressed: () {
                  if (_currentImageIndex < uProduct.images.length - 1) {
                    _carouselController.nextPage();
                  } else {
                    _carouselController.jumpToPage(0);
                  }
                },
                icon: Icon(Icons.arrow_right_outlined, color: theme.iconColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDotsIndicator(Product uProduct) {
    return DotsIndicator(
      dotsCount: uProduct.images.length,
      position: _currentImageIndex,
      decorator: DotsDecorator(
        activeColor: Colors.blueAccent,
        size: const Size.square(8.0),
        activeSize: const Size(18.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(
      CTheme theme, TextTheme textTheme, quill.QuillController controller) {
    return DefaultTextStyle(
      style: TextStyle(color: theme.primTextColor),
      child: quill.QuillEditor(
        focusNode: FocusNode(),
        scrollController: ScrollController(),
        configurations: quill.QuillEditorConfigurations(
          customStyles: quill.DefaultStyles(color: theme.primTextColor),
          scrollable: false,
        ),
        controller: controller,
      ),
    );
  }

  Widget _buildRatingSection(CTheme theme,bool admin,int avgRating){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          admin ? "Average Rating" :'Rate this product:',
          style: TextStyle(
            color: theme.primTextColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: admin ? null : () =>
                  setState(() => rating = rating == index ? -1 : index),
              child: Icon(Icons.star,
                  color: admin ? index <= avgRating  ? Colors.amber : Colors.grey : index <= rating ? Colors.amber : Colors.grey),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProductInfoSection(CTheme theme, double width,Product uProduct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Information',
          style: TextStyle(
            color: theme.primTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    children: [
                      _buildTableCell(
                          'Category:', uProduct.category.name, theme),
                      _buildTableCell('Size:', uProduct.size, theme),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell('Gender:', uProduct.gender, theme),
                      _buildTableCell(
                          'Target Age:', uProduct.targetAge, theme),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell('Delivery:',
                          '${uProduct.delivery} days', theme),
                      _buildTableCell(
                          'Times Sold:', '${uProduct.timesSold}', theme),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell(
                          'Post Date:', uProduct.postDate, theme),
                      const SizedBox.shrink(),
                    ],
                  ),
                ],
              );
            } else {
              return Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  _buildTableRow(
                      'Category:', uProduct.category.name, theme),
                  _buildTableRow('Size:', uProduct.size, theme),
                  _buildTableRow('Gender:', uProduct.gender, theme),
                  _buildTableRow(
                      'Target Age:', uProduct.targetAge, theme),
                  _buildTableRow(
                      'Delivery:', '${uProduct.delivery} days', theme),
                  _buildTableRow(
                      'Times Sold:', '${uProduct.timesSold}', theme),
                  _buildTableRow('Post Date:', uProduct.postDate, theme),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value, CTheme theme) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(
              color: theme.secondaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value,
            style: TextStyle(
              color: theme.primTextColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String label, String value, CTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        label + value,
        style: TextStyle(
          color: theme.secondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
