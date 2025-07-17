import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/cartController.dart';
import 'package:laptop_harbor/controller/wishlistController.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:laptop_harbor/userPanel/Cart.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/rate_us.dart';

class ProductDetail extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetail({super.key, required this.productData});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final WishlistController wishlistController = Get.put(WishlistController());
  final Cartcontroller cartcontroller = Get.put(Cartcontroller());
  bool isFav = false;
  double averageRating = 0.0;
  int totalReviews = 0;

  @override
  void initState() {
    super.initState();
    fetchRatings();
    checkIfInWishlist();
  }

  void checkIfInWishlist() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        isFav = false;
      });
      return;
    }

    final exists = await wishlistController.isInWishlist(
      widget.productData['productId'],
    );
    setState(() {
      isFav = exists;
    });
  }

  Future<void> fetchRatings() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('ratings')
            .where('productId', isEqualTo: widget.productData['productId'])
            .get();

    if (snapshot.docs.isNotEmpty) {
      double sum = 0;
      for (var doc in snapshot.docs) {
        sum += doc['rating'];
      }
      setState(() {
        averageRating = sum / snapshot.docs.length;
        totalReviews = snapshot.docs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.productData;
    final imageBytes = base64Decode(product['productImage']);
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () => Get.to(() => Cart()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: MemoryImage(imageBytes),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Product Name
            Text(
              product['productName'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Price & Favorite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PKR ${product['productPrice']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      redSnackBar(
                        "❌ Login Required!",
                        "Please login to use the wishlist.",
                      );
                      return;
                    }

                    if (isFav) {
                      await wishlistController.removeFromWishlist(
                        widget.productData['productId'],
                      );
                      redSnackBar("Removed", "Product removed from wishlist.");
                    } else {
                      await wishlistController.addToWishlist(
                        widget.productData['productId'],
                      );
                      greenSnackBar("Added", "Product added to wishlist.");
                    }

                    setState(() {
                      isFav = !isFav;
                    });
                  },

                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),

            // Ratings
            if (totalReviews > 0)
              Row(
                children: [
                  RatingBarIndicator(
                    rating: averageRating,
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 22.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "($totalReviews Reviews)",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Description
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              product['productDesc'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 30),

            // Icon Buttons (Add to Cart & Rate Product)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!isLoggedIn) {
                          redSnackBar(
                            '❌ Login Required!',
                            'Please login to add items to cart.',
                          );
                          return;
                        }

                        final productModel = ProductModel.fromMap(product);
                        cartcontroller.AddToCart(productModel);
                        Get.to(() => Cart());
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    const Text("Add to Cart", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!isLoggedIn) {
                          redSnackBar(
                            "Login Required!",
                            "Please login to rate this product.",
                          );
                          return;
                        }

                        Get.to(
                          () => RateUsPage(productId: product['productId']),
                        );
                      },
                      icon: const Icon(
                        Icons.rate_review,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                    const Text("Rate Product", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            const Text(
              "Customer Reviews",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Review List
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('ratings')
                      .where(
                        'productId',
                        isEqualTo: widget.productData['productId'],
                      )
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reviews = snapshot.data!.docs;

                if (reviews.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("No reviews yet."),
                  );
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final data = reviews[index].data() as Map<String, dynamic>;
                    final DateTime? timestamp =
                        data['timestamp'] != null
                            ? (data['timestamp'] as Timestamp).toDate()
                            : null;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['email'] ?? 'User',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (timestamp != null)
                            Text(
                              "${timestamp.day}/${timestamp.month}/${timestamp.year}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            rating: (data['rating'] ?? 0).toDouble(),
                            itemBuilder:
                                (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 16,
                          ),
                          const SizedBox(height: 4),
                          Text(data['review'] ?? ''),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
