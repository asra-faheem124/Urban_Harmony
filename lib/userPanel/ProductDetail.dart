import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/Cart.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: Duration(seconds: 3),
                viewportFraction: 0.9,
              ),
              items:
                  [
                    'assets/images/laptop1.png',
                    'assets/images/laptop4.png',
                  ].map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(imagePath, fit: BoxFit.cover),
                        );
                      },
                    );
                  }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                child: Text(
                  "Apple MacBook Pro Core i9 9th Generation – 16GB RAM, 512GB SSD, 15.4 Retina Display",
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 63, 62, 62),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PKR 2,29,350",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFav = !isFav;
                        });
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 10),
            Text("More Info", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                   padding: const EdgeInsets.only(left:16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.laptop, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 10),
                      Text(
                        "Model: ",
                        style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),
                      ),
                      Text("MacBook Pro 2023"),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(left:16.0),
                  child: Row(
                    
                    children: [
                      Icon(Icons.memory, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 10),
                      Text(
                        "RAM: ",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                      ),
                      Text("16GB DDR5"),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                 padding: const EdgeInsets.only(left:16.0),
                  child: Row(
                   
                    children: [
                      Icon(Icons.sd_storage, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 10),
                      Text(
                        "Storage: ",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                      ),
                      Text("512GB SSD"),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                 padding: const EdgeInsets.only(left:16.0),
                  child: Row(
                    
                    children: [
                      Icon(Icons.battery_full, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 10),
                      Text(
                        "Battery Life: ",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                      ),
                      Text("Up to 20 hours"),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(left:16.0),
                  child: Row(
                   
                    children: [
                      Icon(Icons.security, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 10),
                      Text(
                        "Warranty: ",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                      ),
                      Text("1-Year Apple Warranty"),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                MyButton(title: "Add to Cart", route: Cart()),
                SizedBox(height: 15,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
