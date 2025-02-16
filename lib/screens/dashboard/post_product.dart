import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/card_dimensions.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/repos/main_repo.dart';
import 'package:t_wear/screens/dashboard/widgets/editor.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/prime_button.dart';
import 'package:t_wear/screens/home/widgets/category.dart';
import 'package:uuid/uuid.dart';

class PostProduct extends StatefulWidget {
  const PostProduct({super.key});

  @override
  State<PostProduct> createState() => _PostProductState();
}

class _PostProductState extends State<PostProduct> {
  final ScrollController _scrollController = ScrollController();
  late QuillController
      _editorController; // Made it late to allow reinitialization
  final TextEditingController priceController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController deliveryChargesController =
      TextEditingController();
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  List<XFile> images = [];
  List<Uint8List> imagePreviews = [];
  int? selectedCategory;
  List<Map> products = [];
  List<String> genders = ["Male", "Female"];
  String selectedGender = "Male";
  final FocusNode _fNode = FocusNode();
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();

    // Initialize the Quill editor with an empty document
    _editorController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  void _setUpdateDetails(Product product) {
    setState(() {
      _editorController = QuillController(
        document: Document.fromDelta(
            product.details), // Set QuillController with product details
        selection: const TextSelection.collapsed(offset: 0),
      );
    });

    priceController.text = product.price.toString();
    productNameController.text = product.name;
    discountController.text = product.discount.toString();
    stockController.text = product.stock.toString();
    deliveryChargesController.text = product.delivery.toString();
    brandNameController.text = product.company.toString();
    ageController.text = product.targetAge.toString();
    sizeController.text = product.size.toString();
    selectedGender = product.gender;
    selectedCategory = product.category.id;
  }

  @override
  Widget build(BuildContext context) {
    final CTheme themeMode = getThemeMode(context);
    Color? quillBorder = themeMode.borderColor;
    Product? product = ModalRoute.of(context)!.settings.arguments as Product?;

    _fNode.addListener(() {
      setState(() {
        quillBorder =
            _fNode.hasFocus ? themeMode.borderColor2 : themeMode.borderColor;
      });
    });

    return Scaffold(
      endDrawer: CustomDrawer(themeMode: themeMode),
      backgroundColor: themeMode.backgroundColor,
      appBar:
          NavBar(themeMode: themeMode, scrollController: ScrollController()),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: getScreenSize(context).first * .7,
                  height: getScreenSize(context).elementAt(1) * .6,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: quillBorder ?? Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: TextStyle(color: themeMode.primTextColor),
                    child: DescriptionEditor(
                      editorController: _editorController,
                      scrollController: _scrollController,
                      focusNode: _fNode,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                PrimeButton(
                  action: () async {
                    try {
                      List<String> urls = await uploadImagesToFolder(
                          images, productNameController.text);
                      final category = categories.firstWhere(
                        (cat) => cat.id == selectedCategory,
                        orElse: () => throw Exception("Invalid category"),
                      );
                      products.add(Product(
                        id: Uuid().v1(),
                        size: sizeController.text,
                        name: productNameController.text,
                        price: double.parse(priceController.text),
                        images: urls,
                        stock: int.parse(stockController.text),
                        details: _editorController.document
                            .toDelta(), // Correctly fetching the Delta
                        delivery: int.parse(deliveryChargesController.text),
                        company: brandNameController.text,
                        category: category,
                        gender: selectedGender,
                        discount: double.parse(discountController.text),
                        targetAge: ageController.text.toString(),
                        postDate: DateFormat('dd/MM/yyyy')
                            .format(DateTime.now())
                            .toString(),
                      ).toMap());
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  themeMode: themeMode,
                  width: getScreenSize(context).first <= 420
                      ? responsiveWidth(getScreenSize(context).first) * .85
                      : responsiveWidth(getScreenSize(context).first) * .65,
                  child: Text(
                    "Post Product",
                    style: TextStyle(color: themeMode.primTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
