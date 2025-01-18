import 'category.dart' as cat;

class Product {
  final String name;
  final double price;
  final double? discount;
  final List<String> images;
  final int stock;
  final String details;
  final int delivery;

  final String company;
  final cat.Category category;
  final String size;
  final String gender;
  final String targetAge;

  Product({
    required this.name,
    required this.price,
    this.discount,
    required this.images,
    required this.stock,
    required this.details,
    required this.delivery,
    required this.company,
    required this.category,
    required this.size,
    required this.gender,
    required this.targetAge,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      price: map['price'],
      discount: map['discount'],
      images: List<String>.from(map['images']),
      stock: map['stock'],
      details: map['details'].toString(),
      delivery: map['delivery'],
      company: map['company'],
      category: cat.Category.fromMap(map['category']),
      size: map['size'],
      gender: map['gender'],
      targetAge: map['targetAge'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'discount': discount,
      'images': images,
      'stock': stock,
      'details': details.toString(),
      'delivery': delivery,
      'company': company,
      'category': category.toMap(),
      'size': size,
      'gender': gender,
      'targetAge': targetAge,
    };
  }
}
