import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:t_wear/bloc/home/home_bloc.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/dashboard/widgets/editor.dart';
import 'package:t_wear/screens/dashboard/widgets/img_pick_btn.dart';
import 'package:t_wear/screens/dashboard/widgets/input_decor.dart';
import 'package:t_wear/screens/dashboard/widgets/product_form.dart';
import 'package:t_wear/screens/dashboard/widgets/section_builder.dart';
import 'package:t_wear/screens/global_widgets/custom_drawer.dart';
import 'package:t_wear/screens/global_widgets/loading_indicator.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/home/product_inspection_page.dart';
import 'package:t_wear/screens/home/widgets/category.dart';
import 'package:t_wear/screens/home/widgets/url_identifier.dart';
import 'package:uuid/uuid.dart';

class PostProduct extends StatefulWidget {
  const PostProduct({super.key});

  @override
  State<PostProduct> createState() => _PostProductState();
}

class _PostProductState extends State<PostProduct> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _pgScrollController = ScrollController();
  QuillController _editorController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0));
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

  List<dynamic> imagePreviews = [];
  int? selectedCategory;
  List<Product> products = [];
  List<String> genders = ["Male", "Female", "Unisex"];
  String selectedGender = "Male";
  final FocusNode _fNode = FocusNode();
  bool btnClicked = false;
  bool isUpdating = false;
  Product? product;

  @override
  void dispose() {
    _pgScrollController.dispose();
    _editorController.dispose();
    priceController.dispose();
    productNameController.dispose();
    discountController.dispose();
    stockController.dispose();
    deliveryChargesController.dispose();
    brandNameController.dispose();
    ageController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  void _setUpdateDetails(Product product) {
    _editorController = QuillController(
        document: Document.fromDelta(product.details),
        selection: const TextSelection.collapsed(offset: 0));
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
    imagePreviews.addAll(product.images);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (product != null) {
        _setUpdateDetails(product!);
        isUpdating = true;
        setState(() {});
      }
    });
    _editorController.document.changes.listen((event) {
      _limitCharacters();
    });
  }

  void _limitCharacters() {
    final plainText = _editorController.document.toPlainText();
    if (plainText.length > 700) {
      String truncatedText = plainText.substring(0, 700);

      _editorController.document = Document()..insert(0, truncatedText);

      _editorController.updateSelection(
        TextSelection.collapsed(offset: truncatedText.length),
        ChangeSource.local,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final [width, height] = getScreenSize(context);
    final CTheme themeMode = getThemeMode(context);
    Color? quillBorder = themeMode.borderColor;
    product = ModalRoute.of(context)!.settings.arguments as Product?;

    _fNode.addListener(() {
      setState(() {
        quillBorder =
            _fNode.hasFocus ? themeMode.borderColor2 : themeMode.borderColor;
      });
    });

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeSuccess && btnClicked) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isUpdating) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailPage(product: products.first)));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(isUpdating
                      ? "Product updated Successfully you can now review changes"
                      : "New Product Addition Successfull.")));
            } else {
              Navigator.pop(context);
            }
          });
        }
        return Stack(
          children: [
            Scaffold(
              endDrawer: CustomDrawer(themeMode: themeMode),
              backgroundColor: themeMode.backgroundColor,
              appBar: NavBar(
                  themeMode: themeMode, scrollController: ScrollController()),
              body: SingleChildScrollView(
                controller: _pgScrollController,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        buildSection(
                          themeMode: themeMode,
                          sectionTitle: "Product Info",
                          items: [],
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: width * .7,
                          child: ProductForm(
                            themeMode: themeMode,
                            formKey: formKey,
                            productNameController: productNameController,
                            priceController: priceController,
                            discountController: discountController,
                            stockController: stockController,
                            deliveryChargesController:
                                deliveryChargesController,
                            brandNameController: brandNameController,
                            sizeController: sizeController,
                            ageController: ageController,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: width * .7,
                          child: DropdownButtonFormField<String>(
                            style: TextStyle(color: themeMode.primTextColor),
                            value: selectedGender,
                            dropdownColor: themeMode.backgroundColor,
                            decoration: inputDecor(
                                ht: "Select Gender",
                                hit: "Select Gender",
                                icon: Icons.man_4,
                                themeMode: themeMode),
                            items: genders
                                .map((gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender,
                                          style: TextStyle(
                                              color:
                                                  themeMode.oppositeTextColor)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: width * .7,
                          child: DropdownButtonFormField<int>(
                            style: TextStyle(color: themeMode.primTextColor),
                            value: selectedCategory,
                            dropdownColor: themeMode.backgroundColor,
                            decoration: inputDecor(
                                ht: "Select Category",
                                hit: "Select Category",
                                icon: Icons.category,
                                themeMode: themeMode),
                            items: categories
                                .map((category) => DropdownMenuItem(
                                      value: category.id,
                                      child: Text(
                                        category.name,
                                        style: TextStyle(
                                            color: themeMode.oppositeTextColor),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: width * .7,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: themeMode.borderColor ?? Colors.red,
                                width: 2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)),
                          ),
                          child: ToolBar(
                              editorController: _editorController,
                              themeMode: themeMode),
                        ),
                        Container(
                            width: width * .7,
                            height: height * .6,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: quillBorder ?? Colors.red, width: 2),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DefaultTextStyle(
                                style:
                                    TextStyle(color: themeMode.primTextColor),
                                child: DescriptionEditor(
                                    editorController: _editorController,
                                    scrollController: _scrollController,
                                    focusNode: _fNode))),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 5,
                          children: [
                            if (imagePreviews.length < 6)
                              ImagesButton(
                                onpress: () async {
                                  final pickedImages =
                                      await _imagePicker.pickMultiImage();
                                  imagePreviews.addAll([
                                    for (XFile img in pickedImages)
                                      await img.readAsBytes()
                                  ]);
                                  pickedImages.clear();
                                },
                                themeMode: themeMode,
                              ),
                            ...imagePreviews.map(
                              (image) => Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color:
                                                  themeMode.borderColor2 ?? Colors.red)),
                                      child: isValidUrl(image.toString())
                                          ? Image.network(
                                              image,
                                              width: width <= 420
                                                  ? width * .33
                                                  : width * .22,
                                              height: height * .2,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.memory(
                                              image,
                                              width: width <= 420
                                                  ? width * .33
                                                  : width * .22,
                                              height: height * .2,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: themeMode.borderColor2,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          final index =
                                              imagePreviews.indexOf(image);
                                          imagePreviews.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 70, maxWidth: 200),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            onPressed: isUpdating
                                ? () async {
                                    if (formKey.currentState!.validate()) {
                                      if (imagePreviews.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please Select Atleast One Image.")));
                                        return;
                                      }
                                      final category = categories.firstWhere(
                                        (cat) => cat.id == selectedCategory,
                                        orElse: () =>
                                            throw Exception("Invalid category"),
                                      );
                                      btnClicked = !btnClicked;
                                      var updatedProduct = Product(
                                        id: product!.id,
                                        rating: product!.rating,
                                        postDate: product!.postDate,
                                        size: sizeController.text,
                                        name: productNameController.text,
                                        price:
                                            double.parse(priceController.text),
                                        images: imagePreviews,
                                        stock: int.parse(stockController.text),
                                        details: _editorController.document
                                            .toDelta(),
                                        delivery: int.parse(
                                            deliveryChargesController.text),
                                        company: brandNameController.text,
                                        category: category,
                                        gender: selectedGender,
                                        discount: double.parse(
                                            discountController.text),
                                        targetAge:
                                            ageController.text.toString(),
                                      );
                                      products.add(updatedProduct);
                                      context.read<HomeBloc>().add(
                                          UpdateProduct(
                                              product: updatedProduct));
                                    }
                                  }
                                : () async {
                                    try {
                                      if (formKey.currentState!.validate()) {
                                        if (imagePreviews.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please Select Atleast One Image.")));
                                          return;
                                        }
                                        final category = categories.firstWhere(
                                          (cat) => cat.id == selectedCategory,
                                          orElse: () => throw Exception(
                                              "Invalid category"),
                                        );
                                        btnClicked = !btnClicked;
                
                                        context.read<HomeBloc>().add(AddProduct(
                                                product: Product(
                                              id: Uuid().v1(),
                                              size: sizeController.text,
                                              name: productNameController.text,
                                              price: double.parse(
                                                  priceController.text),
                                              images: imagePreviews,
                                              stock: int.parse(
                                                  stockController.text),
                                              details: _editorController
                                                  .document
                                                  .toDelta(),
                                              delivery: int.parse(
                                                  deliveryChargesController
                                                      .text),
                                              company: brandNameController.text,
                                              category: category,
                                              gender: selectedGender,
                                              discount: double.parse(
                                                  discountController.text),
                                              targetAge:
                                                  ageController.text.toString(),
                                              postDate: DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now())
                                                  .toString(),
                                            )));
                                      }
                                    } catch (e) {
                                      print("Error: $e");
                                    }
                                  },
                            child: Text(
                              isUpdating ? "Push Updates" : "Post Product",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width <= 600 ? 16 : 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (state is HomeLoading)
                  ...[Container(color: Colors.black.withValues(alpha: .3),width: width, height: height,),
                  SizedBox(height: 4, child: ColorChangingProgressIndicator()),]
          ],
        );
      },
    );
  }
}
