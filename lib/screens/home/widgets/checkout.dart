import 'package:flutter/material.dart';

void showCheckoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more screen space
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Checkout',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                buildTextField('Shipping Address', Icons.location_on),
                SizedBox(height: 10),
                buildTextField('Card Number', Icons.credit_card),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField('Expiry Date', Icons.calendar_today),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildTextField('CVV', Icons.lock),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle order placement logic
                    Navigator.pop(context); // Close the bottom sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order Placed Successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Place Order'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
