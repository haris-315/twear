import 'package:t_wear/models/product_model.dart';

List<Map<String, dynamic>> productsMaps = [
  {
    "name": "New Hoods For Boys And Girls With New Print BTS",
    "price": 750,
    "discount": null,
    "images": [
      "https://res.cloudinary.com/dume7lvn5/image/upload/v1737214178/New%20Hoods%20For%20Boys%20And%20Girls%20With%20New%20Print%20BTS/Sd3e7123dcda844419b10d5b58bf6a605i.jpg_720x720q80.jpg__auqxm8.webp"
    ],
    "stock": 12,
    "details": """[
      {"insert": "Introducing "},
      {
        "insert": "our new hoods",
        "attributes": {"bold": true, "color": "#FFEC407A"}
      },
      {
        "insert":
            " for boys and girls with a trendy BTS print! Perfect for any casual occasion, these hoods are a must-have addition to your child's wardrobe. Made with high-quality materials, they are durable and "
      },
      {
        "insert": "comfortable",
        "attributes": {"color": "#FF4CAF50", "bold": true}
      },
      {"insert": " to wear. The "},
      {
        "insert": "design is suitable for both boys and girls",
        "attributes": {"underline": true}
      },
      {
        "insert":
            ", making it a versatile choice. These hoods are perfect for keeping your child warm during the colder months. Available in a variety of sizes to fit any age range, they are a great choice for any fashion-conscious parent. Upgrade your child's wardrobe with our "
      },
      {
        "insert": "stylish",
        "attributes": {"color": "#FFFDD835"}
      },
      {"insert": " and "},
      {
        "insert": "comfortable",
        "attributes": {"color": "#FF4CAF50"}
      },
      {"insert": " hoods today!"}
    ]""",
    "delivery": 142,
    "company": "BTS Collection",
    "category": {"name": "Men", "id": 2, "image": "images/c2.webp"},
    "size": "XL",
    "gender": "Male",
    "targetAge": 18
  }
];

List<Product> getProducts() {
  List<Product> products =
      productsMaps.map((element) => Product.fromMap(element)).toList();

  return products;
}
