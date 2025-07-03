import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/Checkout/Bar.dart';
import 'package:laptop_harbor/userPanel/Home.dart';
import 'package:laptop_harbor/userPanel/constant.dart';
// import 'package:grocerystore/Login.dart';

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
  });
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

List<ProductItem> prodList = [
  ProductItem(
    image: "assets/images/laptop1.png",
    name: "Apple MacBook",
    description: "i9 9th Gen",
    price: "PKR 150",
  ),
  ProductItem(
    image: "assets/images/laptop3.png",
    name: "MacBook Pro 14",
    description: "i9 9th Gen",
    price: "PKR 300",
  ),
  ProductItem(
    image: "assets/images/laptop2.png",
    name: "MacBook Pro 14",
    description: "i9 9th Gen",
    price: "PKR 150",
  ),
  // ProductItem(
  //   image: "assets/images/cart4.png",
  //   name: "Coca Cola Can",
  //   description: "325ml Price",
  //   price: "PKR 150",
  // ),
  // ProductItem(
  //   image: "assets/images/cart5.png",
  //   name: "Pepsi Can",
  //   description: "325ml Price",
  //   price: "PKR 150",
  // ),
];

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "My Cart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey),
            Expanded(
              child: ListView.separated(
                itemCount: prodList.length,
                separatorBuilder:
                    (context, index) =>
                        const Divider(thickness: 1, color: Colors.grey),
                itemBuilder: (context, index) {
                  final item = prodList[index];
                  return ListTile(
                    leading: Image.asset(item.image, width: 100, height: 100),
                    title: Text(
                      item.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                            SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: const CircleBorder(),
                              ),
                              child: Text(
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            MyButton(title: 'Go To Checkout', route: StepperUI()),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
