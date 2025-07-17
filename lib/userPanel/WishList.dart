import 'package:flutter/material.dart';

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

class WishList extends StatelessWidget {
  List<ProductItem> prodList = [
    ProductItem(
      image: "assets/images/Dell G15 Gaming.png",
      name: "Apple MacBook",
      description: "i9 9th Gen",
      price: "PKR 150",
    ),
    ProductItem(
      image: "assets/images/Lenovo IdeaPad Slim 3.png",
      name: "MacBook Pro 14",
      description: "i9 9th Gen",
      price: "PKR 300",
    ),
    ProductItem(
      image: "assets/images/Dell G15 Gaming.png",
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
                "Wish List",
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
                        Text(
                          item.price,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite),
                        SizedBox(width: 10,),
                        Icon(Icons.delete)
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
