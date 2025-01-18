import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/screens/dashboard/widgets/input_decor.dart';

class ProductForm extends StatefulWidget {
  final CTheme themeMode;
  final GlobalKey formKey;
  final TextEditingController productNameController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController stockController;
  final TextEditingController deliveryChargesController;
  final TextEditingController brandNameController;
  final TextEditingController ageController;
  final TextEditingController sizeController;

  const ProductForm(
      {super.key,
      required this.formKey,
      required this.themeMode,
      required this.productNameController,
      required this.priceController,
      required this.discountController,
      required this.stockController,
      required this.deliveryChargesController,
      required this.brandNameController,
      required this.ageController,
      required this.sizeController});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  String? _validateRequired(String? value, String fieldName,
      {bool isAge = false}) {
    if (value == null || value.isEmpty) {
      return "$fieldName cannot be empty";
    }
    if (isAge && int.parse(value) >= 61) {
      return "Target Age must be between 1-60 years";
    }
    return null;
  }

  String? _validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName cannot be empty";
    }
    if (double.tryParse(value) == null) {
      return "$fieldName must be a valid number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Form(
      key: widget.formKey,
      child: isWideScreen
          ? GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 fields per row
                crossAxisSpacing: 16,
                mainAxisExtent: 80,
                mainAxisSpacing: 16,
                // childAspectRatio: 3, // Adjust for heigthemeMode: widget.themeMode,ht/width ratio
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: _buildFormFields(),
            )
          : Column(children: fixColumnView()),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      TextFormField(
        controller: widget.productNameController,
        decoration: inputDecor(
          themeMode: widget.themeMode,
          ht: "Product Name",
          hit: "Product Name",
          icon: Icons.text_snippet_outlined,
        ),
        validator: (value) => _validateRequired(value, "Product Name"),
      ),
      TextFormField(
        controller: widget.priceController,
        decoration: inputDecor(
          themeMode: widget.themeMode,
          ht: "Price",
          hit: "Product Price",
          icon: Icons.attach_money,
        ),
        keyboardType: TextInputType.number,
        validator: (value) => _validateNumeric(value, "Price"),
      ),
      TextFormField(
        controller: widget.discountController,
        decoration: inputDecor(
          themeMode: widget.themeMode,
          ht: "Discount",
          hit: "Discount if any",
          icon: Icons.discount_outlined,
        ),
        keyboardType: TextInputType.number,
        validator: (value) => _validateNumeric(value, "Discount"),
      ),
      TextFormField(
        controller: widget.stockController,
        decoration: inputDecor(
          themeMode: widget.themeMode,
          ht: "Stock",
          hit: "Product Quantity",
          icon: Icons.inventory_2_outlined,
        ),
        keyboardType: TextInputType.number,
        validator: (value) => _validateNumeric(value, "Stock"),
      ),
      TextFormField(
        controller: widget.deliveryChargesController,
        decoration: inputDecor(
          themeMode: widget.themeMode,
          ht: "Delivery Charges",
          hit: "Delivery charges if applies",
          icon: Icons.local_shipping_outlined,
        ),
        keyboardType: TextInputType.number,
        validator: (value) => _validateNumeric(value, "Delivery Charges"),
      ),
      TextFormField(
        controller: widget.brandNameController,
        decoration: inputDecor(
          themeMode: widget.themeMode,
          ht: "Brand Name",
          hit: "Product's Manufacturer Name",
          icon: Icons.factory_outlined,
        ),
        validator: (value) => _validateRequired(value, "Brand Name"),
      ),
      TextFormField(
        controller: widget.ageController,
        keyboardType: TextInputType.number,
        decoration: inputDecor(
          themeMode: widget.themeMode,
          ht: "Target Age",
          hit: "Age of the the target costumers",
          icon: Icons.watch_later,
        ),
        validator: (value) => _validateRequired(value, "Age", isAge: true),
      ),
      TextFormField(
        controller: widget.sizeController,
        decoration: inputDecor(
          themeMode: widget.themeMode,
          ht: "Product Size",
          hit: "Size of the product in roman numerals",
          icon: Icons.watch_later,
        ),
        validator: (value) => _validateRequired(value, "Size"),
      ),
    ];
  }

  List<Widget> fixColumnView() {
    List<Widget> items = [];
    List<Widget> fields = _buildFormFields();
    for (int i = 0; i < fields.length; i++) {
      items = [
        ...items,
        fields.elementAt(i),
        const SizedBox(
          height: 15,
        )
      ];
    }
    fields.clear();
    return items;
  }
}
