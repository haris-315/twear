import 'package:fpdart/fpdart.dart';
import 'package:t_wear/models/category.dart';
import 'package:t_wear/models/failure.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/home/widgets/category.dart';

class ProductsRepo {
  List<Product> products =
      productsMaps.map((element) => Product.fromMap(element)).toList();
  Map<dynamic, List<Product>> categorizedProducts = {"trending": <Product>[]};

  Future<Either<Failure, Map<dynamic, List<Product>>>> getProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      for (var category in categories) {
        List<Product> trending =
            products.where((product) => product.avgRating() == 5).toList();
        categorizedProducts['trending'] = trending;
        List<Product> tempProductsList = products
            .where((product) => product.category.id == category.id)
            .toList();
        if (tempProductsList.isNotEmpty) {
          categorizedProducts[category.name] = tempProductsList;
        }
      }

      return right(categorizedProducts);
    } catch (e) {
      return left(Failure(message: e.toString(), st: StackTrace.current));
    }
  }

  Future<Either<Failure, Map<dynamic, List<Product>>>> getProductsByCategory(
      Category category) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      categorizedProducts.removeWhere((key, value) => key != "tending");

      categorizedProducts[category.name] = products
          .where((product) => product.category.id == category.id)
          .toList();
      return right(categorizedProducts);
    } catch (e) {
      return left(Failure(message: e.toString(), st: StackTrace.current));
    }
  }
}

List<Map<String, dynamic>> productsMaps = [
  {
    "name": "New Hoods For Boys With New Print BTS",
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
    "targetAge": 18,
    'rating': [0],
    'postDate': '24/01/2025'
  },
  {
    'name':
        'Fashion Women Faux Rabbit Fur Hand Wrist Warmer Winter Fingerless Knitted Gloves',
    'price': 279,
    'discount': 42,
    'images': [
      'https://res.cloudinary.com/dume7lvn5/image/upload/v1737458684/Fashion%20Women%20Faux%20Rabbit%20Fur%20Hand%20Wrist%20Warmer%20Winter%20Fingerless%20Knitted%20Gloves/2fced68cffd8abceddd6ea79a721953d.jpg_720x720q80.jpg__ot4ehw.webp'
    ],
    'stock': 19,
    'details': """[
    {'insert': 'Best'},
    {'insert': 'Woolen Gloves', 'attributes': {'bold': true, 'color': '#FFE91E63'}},
    {'insert': 'For'},
    {'insert': 'Girls', 'attributes': {'bold': true}},
    {'insert': 'Under The'},
    {'insert': 'Age Of 12 to 18', 'attributes': {'bold': true}},
    {'insert': 'To'},
    {'insert': 'Protect', 'attributes': {'bold': true}},
    {'insert': 'Their'},
    {'insert': 'Hands', 'attributes': {'bold': true}},
    {'insert': 'From'},
    {'insert': 'Cold', 'attributes': {'bold': true}},
    {'insert': 'Type', 'attributes': {'bold': true}},
    {'insert': ': Gloves'},
    {'insert': '\n', 'attributes': {'list': 'bullet'}},
    {'insert': 'Gender', 'attributes': {'bold': true}},
    {'insert': ': Women'},
    {'insert': '\n', 'attributes': {'list': 'bullet'}},
    {'insert': 'Material', 'attributes': {'bold': true}},
    {'insert': ': Faux Fur, Woolen Yarn'},
    {'insert': '\n', 'attributes': {'list': 'bullet'}},
    {'insert': 'Season', 'attributes': {'bold': true}},
    {'insert': ': Winter'},
    {'insert': '\n', 'attributes': {'list': 'bullet'}},
    {'insert': 'Occasions', 'attributes': {'bold': true}},
    {'insert': ': Party, Shopping, Dating, School, Travel, etc'},
    {'insert': '\n', 'attributes': {'list': 'bullet'}},
    {'insert': 'Features', 'attributes': {'bold': true}},
    {'insert': ': Faux Fur, Fingerless, Warm, Soft, Elastic'},
    {'insert': '\n', 'attributes': {'list': 'bullet'}},
    {'insert': 'Length', 'attributes': {'bold': true}},
    {'insert': ': 13cm/5.12", Width: 9cm/3.54" (Approx.)'},
    {'insert': '\n', 'attributes': {'list': 'bullet'}},
    {'insert': 'Note', 'attributes': {'bold': true}},
    {'insert': ': No colour Demands Will Be Proceed In Random Colour Variation'},
    {'insert': '\n', 'attributes': {'list': 'bullet'}}
  ]""",
    'delivery': 145,
    'company': 'FashType',
    'category': {
      'name': 'Fashion',
      'id': 1,
      'image':
          'https://res.cloudinary.com/dume7lvn5/image/upload/v1737218212/c1_vl9lgi.webp'
    },
    'size': 'Adjustable',
    'gender': 'Female',
    'targetAge': '12-18',
    'rating': [2, 5, 3, 2, 4, 1],
    'postDate': '24/01/2025'
  },
  {
    'name': 'Unique Style winter track suit for Papa lover kids',
    'price': 999,
    'discount': null,
    'images': [
      'https://res.cloudinary.com/dume7lvn5/image/upload/v1737729103/Unique%20Style%20winter%20track%20suit%20for%20Papa%20lover%20kids/Se70f6c33ce47495fbf9a6f8cfd1b9247I.jpg_720x720q80.jpg__mbg3tw.webp',
      'https://res.cloudinary.com/dume7lvn5/image/upload/v1737729105/Unique%20Style%20winter%20track%20suit%20for%20Papa%20lover%20kids/Se70f6c33ce47495fbf9a6f8cfd1b9247I.jpg_720x720q80.jpg__pxisz5.webp'
    ],
    'details': """[
        {'insert': 'This'},
        {'insert': 'winter track', 'attributes': {'bold': true, 'underline': true, 'color': '#FFE91E63'}},
        {'insert': ' suit is a must-have for kids who love to stay cozy and stylish. The high-quality fleece material ensures that your child stays warm and comfortable during the colder months. '},
        {'insert': 'The pull-over style hoodie is perfect for casual occasions', 'attributes': {'bold': true, 'underline': true, 'italic': true, 'background': '#FFF06292'}},
        {'insert': ' and is designed to keep your child snug. The unique design of this hoodie is sure to make your child stand out from the crowd. It is suitable for both boys and girls and is available in a range of sizes to fit your child perfectly. Whether your child is playing outside or lounging at home, this hoodie is a great addition to their wardrobe, '},
        {'insert': 'providing both comfort and style', 'attributes': {'bold': true, 'color': '#FF4CAF50', 'underline': true}},
        {'insert': '.', 'attributes': {'bold': true}}
      ]""",
    'stock': 17,
    'delivery': 145,
    'timesSold': 0,
    'company': 'KNC',
    'category': {
      'name': "Kid's",
      'id': 7,
      'image':
          'https://res.cloudinary.com/dume7lvn5/image/upload/v1737218227/c7_tyirhd.webp'
    },
    'size': 'S & M',
    'gender': 'Male',
    'targetAge': '3-6',
    'rating': [5, 5, 5, 5, 5],
    'postDate': '24/01/2025'
  }
];
