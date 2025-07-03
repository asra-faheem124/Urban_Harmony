import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/Checkout/Confirmation.dart';

class ProductItem {
  final String image;
  final String name;
  final String description;
  final String price;
  int quantity;

  ProductItem({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    this.quantity = 1,
  }); // ProductItem constructor
} // ProductItem class

class Review extends StatefulWidget {
  const Review({super.key}); // Review constructor

  @override
  State<Review> createState() => _ReviewState(); // createState override
} // Review class

class _ReviewState extends State<Review> {
  // Product list to be reviewed
  List<ProductItem> prodList = [
    ProductItem(
      image: "assets/images/laptop1.png",
      name: "Apple MacBook",
      description: "i9 9th Gen",
      price: "PKR 150",
    ), // Product 1
    ProductItem(
      image: "assets/images/laptop3.png",
      name: "MacBook Pro 14",
      description: "i9 9th Gen",
      price: "PKR 300",
    ), // Product 2
    // Product 3
  ]; // prodList

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Use full screen height
      child: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Review Your Order",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...prodList.map((item) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Image.asset(
                            item.image,
                            width: 100,
                            height: 100,
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.description),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 4),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: const CircleBorder(),
                                    ),
                                    child: const Text(
                                      "+",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(
                            item.price,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(thickness: 1),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Bottom fixed summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ],
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Total amount",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "PKR 2,29.350",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Shipping Fee",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "PKR 300",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Get.offAll(Confirmation());
                    },
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
