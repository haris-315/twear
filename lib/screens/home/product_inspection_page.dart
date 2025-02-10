import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:t_wear/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  double get discountedPrice => product.discount != null
      ? product.price - (product.price * (product.discount! / 100))
      : product.price;

  double get averageRating => product.rating.isNotEmpty
      ? product.rating.reduce((a, b) => a + b) / product.rating.length
      : 0.0;

  @override
  Widget build(BuildContext context) {
    quill.QuillController _controller = quill.QuillController(
      document: quill.Document.fromDelta(product.details),
      readOnly: true,
      selection: TextSelection.collapsed(offset: 0),
    );

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            CarouselSlider(
              options: CarouselOptions(height: 250.0, autoPlay: true),
              items: product.images.map((url) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(product.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                  SizedBox(height: 8),

                  // Price & Discount
                  Row(
                    children: [
                      Text("\$${discountedPrice.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      if (product.discount != null)
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("\$${product.price}",
                              style: TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, color: Colors.red)),
                        ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Stock & Delivery Info
                  Text(product.stock > 0 ? "In Stock (${product.stock} available)" : "Out of Stock",
                      style: TextStyle(color: product.stock > 0 ? Colors.green : Colors.red, fontSize: 16)),

                  Text("Delivery: ${product.delivery} days", style: TextStyle(fontSize: 16)),
                  Text("Sold: ${product.timesSold} times", style: TextStyle(fontSize: 16)),

                  SizedBox(height: 16),

                  // Product Details (Rendered using Quill)
                  Text("Product Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: quill.QuillEditor(
  controller: _controller,
  focusNode: FocusNode(),
  scrollController: ScrollController(),
 configurations: quill.QuillEditorConfigurations(
   scrollable: true,
  padding: EdgeInsets.all(8.0),
  autoFocus: false,
  expands: false,
 ),
),
                  ),

                  SizedBox(height: 16),

                  // Additional Info
                  Text("Company: ${product.company}", style: TextStyle(fontSize: 16)),
                  Text("Category: ${product.category.name}", style: TextStyle(fontSize: 16)),
                  Text("Size: ${product.size}", style: TextStyle(fontSize: 16)),
                  Text("Gender: ${product.gender}", style: TextStyle(fontSize: 16)),
                  Text("Target Age: ${product.targetAge}", style: TextStyle(fontSize: 16)),

                  SizedBox(height: 16),

                  // Ratings
                  Row(
                    children: [
                      Text("Rating: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      Text(averageRating.toStringAsFixed(1), style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Date Posted
                  Text("Posted on: ${product.postDate}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
