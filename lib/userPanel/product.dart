import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/ProductDetail.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  
  State<ProductsScreen> createState() => _ProductsScreenState(); 
}

class _ProductsScreenState extends State<ProductsScreen> {
      String _sortOption = 'None';
List<QueryDocumentSnapshot> _allProducts = [];
  Future<Map<String, dynamic>> _getRatings(String productId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('productId', isEqualTo: productId)
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['rating'];
    }
    double average = snapshot.docs.isEmpty ? 0 : total / snapshot.docs.length;
    return {
      'average': average,
      'count': snapshot.docs.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Laptops', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('products').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No products found."));
    }

    // Save products
    _allProducts = snapshot.data!.docs;

    // Apply sorting
    List<QueryDocumentSnapshot> sortedProducts = [..._allProducts];

    if (_sortOption == 'Price: Low to High') {
      sortedProducts.sort((a, b) => (a['productPrice']).compareTo(b['productPrice']));
    } else if (_sortOption == 'Price: High to Low') {
      sortedProducts.sort((a, b) => (b['productPrice']).compareTo(a['productPrice']));
    }

return Column(
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Sort by:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
  padding: const EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade400),
    borderRadius: BorderRadius.circular(12),
    color: Colors.grey.shade100,
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: _sortOption,
      icon: const Icon(Icons.keyboard_arrow_down),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      items: [
        'None',
        'Price: Low to High',
        'Price: High to Low',
        'Rating: High to Low'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _sortOption = value!;
        });
      },
    ),
  ),
)

        ],
      ),
    ),
    Expanded(
      child: ListView.builder(
        itemCount: sortedProducts.length,
        itemBuilder: (context, index) {
          final product = sortedProducts[index].data() as Map<String, dynamic>;
          final productId = product['productId'];
          Uint8List imageBytes = base64Decode(product['productImage']);

          return FutureBuilder<Map<String, dynamic>>(
            future: _getRatings(productId),
            builder: (context, ratingSnapshot) {
              double avg = ratingSnapshot.data?['average'] ?? 0.0;
              int count = ratingSnapshot.data?['count'] ?? 0;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          imageBytes,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['productName'] ?? '',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  avg.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '($count Reviews)',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rs ${product['productPrice'] ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                MyButton(
                                  title: 'Details',
                                  height: 40,
                                  onPressed: () => Get.to(ProductDetail(productData: product)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  ],
);

        },
      ),
    );
  }
}
