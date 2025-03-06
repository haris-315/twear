import 'package:flutter/material.dart';
import 'package:t_wear/bloc/dashboard/dashboard_bloc.dart';
import 'package:t_wear/models/product_model.dart';
import 'package:t_wear/screens/home/widgets/url_identifier.dart';

class PendingOrders extends StatelessWidget {
  final List<DBP> products;

  const PendingOrders({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final image = product.product.images.first;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            shadowColor: Colors.grey.withOpacity(0.2),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: isValidUrl(image.toString())
                    ? Image.network(
                        image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(
                        image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
              ),
              title: Text(
                product.product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    children: [
                      const TextSpan(
                        text: "Ordered By: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "mail$index@mail.com\n",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(
                        text: "Address: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "DemoAddress$index\n",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(
                        text: "Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "$index/02/2025",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
