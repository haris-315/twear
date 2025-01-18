// ignore: avoid_web_libraries_in_flutter
// ignore_for_file: unused_field

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/repos/main_repo.dart';
import 'package:t_wear/screens/dashboard/widgets/img_pick_btn.dart';
import 'package:t_wear/screens/dashboard/widgets/input_decor.dart';
import 'package:t_wear/screens/dashboard/widgets/product_form.dart';
import 'package:t_wear/screens/dashboard/widgets/section_builder.dart';
import 'package:t_wear/screens/global_widgets/navbar.dart';
import 'package:t_wear/screens/global_widgets/prime_button.dart';
import 'package:t_wear/screens/home/widgets/category.dart';

class PostProduct extends StatefulWidget {
  const PostProduct({super.key});

  @override
  State<PostProduct> createState() => _PostProductState();
}

class _PostProductState extends State<PostProduct> {
  final ScrollController _scrollController = ScrollController();
  final QuillController _editorController = QuillController.basic();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController deliveryChargesController =
      TextEditingController();
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final GlobalKey formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  List<html.File> images = [];
  List<String> imagePreviews = [];
  int? selectedCategory;
  List<Map> products = [];
  List<String> genders = ["Male", "Female"];
  String selectedGender = "Male";
  final FocusNode _fNode = FocusNode();
  bool isLoading = false;
  bool isError = false;

  List<html.File> removeElementAtIndex(List<html.File> list, int index) {
    return list
        .asMap()
        .entries
        .where((entry) => entry.key != index)
        .map((e) => e.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = getScreenSize(context).first;
    final height = getScreenSize(context).elementAt(1);
    final CTheme themeMode = getThemeMode(context);
    Color? quillBorder = themeMode.borderColor;

    _fNode.addListener(() {
      setState(() {
        quillBorder =
            _fNode.hasFocus ? themeMode.borderColor2 : themeMode.borderColor;
      });
    });

    return Scaffold(
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
                    deliveryChargesController: deliveryChargesController,
                    brandNameController: brandNameController,
                    sizeController: sizeController,
                    ageController: ageController,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: width * .7,
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: inputDecor(
                        ht: "Select Gender",
                        hit: "Select Gender",
                        icon: Icons.man_4,
                        themeMode: themeMode),
                    items: genders
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
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
                    value: selectedCategory,
                    decoration: inputDecor(
                        ht: "Select Category",
                        hit: "Select Category",
                        icon: Icons.category,
                        themeMode: themeMode),
                    items: categories
                        .map((category) => DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
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
                  height: height * .6,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: quillBorder ?? Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: TextStyle(color: themeMode.primTextColor),
                    child: Column(
                      children: [
                        QuillEditor(
                          controller: _editorController,
                          scrollController: _scrollController,
                          focusNode: _fNode,
                          configurations: const QuillEditorConfigurations(
                            scrollable: true,
                            autoFocus: false,
                            expands: false,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                QuillToolbar.simple(
                  controller: _editorController,
                  configurations: QuillSimpleToolbarConfigurations(
                    multiRowsDisplay: true,
                    showBackgroundColorButton: true,
                    showUndo: true,
                    showRedo: true,
                    showListNumbers: true,
                    showCodeBlock: true,
                    showQuote: true,
                    showDirection: true,
                    showSearchButton: false,
                    showFontSize: true,
                    dialogTheme: QuillDialogTheme(
                        labelTextStyle:
                            TextStyle(color: themeMode.primTextColor),
                        buttonTextStyle:
                            TextStyle(color: themeMode.primTextColor),
                        buttonStyle: ButtonStyle(
                            textStyle: WidgetStateProperty.resolveWith((_) =>
                                TextStyle(color: themeMode.primTextColor)))),
                    buttonOptions: QuillSimpleToolbarButtonOptions(
                      base: QuillToolbarBaseButtonOptions(
                        iconTheme: QuillIconTheme(
                          iconButtonSelectedData:
                              IconButtonData(color: themeMode.primTextColor),
                          iconButtonUnselectedData:
                              IconButtonData(color: themeMode.primTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 5,
                  children: [
                    if (images.length < 6)
                      ImagesButton(
                        onpress: () async {
                          List<html.File> pickedImages =
                              await pickMultipleImages();

                          for (var image in pickedImages) {
                            final reader = html.FileReader();
                            reader.readAsDataUrl(image);

                            reader.onLoadEnd.listen((_) {
                              setState(() {
                                imagePreviews.add(reader.result as String);
                              });
                            });
                          }

                          setState(() {
                            images = pickedImages;
                          });
                        },
                        themeMode: themeMode,
                      ),
                    ...imagePreviews.map(
                      (imageUri) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color:
                                          themeMode.borderColor ?? Colors.red)),
                              child: Image.network(
                                  width: width * .12,
                                  height: height * .2,
                                  imageUri,
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Positioned(
                              left: 10,
                              top: 20,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      images = [];
                                      images = removeElementAtIndex(images,
                                          imagePreviews.indexOf(imageUri));
                                      imagePreviews.remove(imageUri);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: themeMode.primTextColor,
                                  )))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PrimeButton(
                    action: () {
                      print(products);
                    },
                    themeMode: themeMode,
                    width: width * .2,
                    child: const Text("Print Products")),
                const SizedBox(height: 10),
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
                        size: sizeController.text,
                        name: productNameController.text,
                        price: double.parse(priceController.text),
                        images: urls,
                        stock: int.parse(stockController.text),
                        details: _editorController.document
                            .toDelta()
                            .toJson()
                            .toString(),
                        delivery: int.parse(deliveryChargesController.text),
                        company: brandNameController.text,
                        category: category,
                        gender: selectedGender,
                        targetAge: ageController.text.toString(),
                      ).toMap());
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  themeMode: themeMode,
                  width: width * .2,
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

Future<List<html.File>> pickMultipleImages() async {
  final input = html.FileUploadInputElement();
  input.accept = 'image/*';
  input.multiple = true;
  input.click();

  await input.onChange.first;

  final files = input.files;
  if (files != null) {
    return files;
  }

  return [];
}
