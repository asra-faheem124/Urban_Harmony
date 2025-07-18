import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/ProductDetail.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _sortOption = 'None';
  String _selectedCategory = 'All';
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _products = [];
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    final catSnap = await FirebaseFirestore.instance.collection('category').get();
    Map<String, String> catMap = {
      for (var c in catSnap.docs) c['categoryId']: c['categoryName']
    };
    _categories = ['All', ...catMap.values.toSet()];

    final prodSnap = await FirebaseFirestore.instance.collection('products').get();
    List<Map<String, dynamic>> temp = [];

    for (var p in prodSnap.docs) {
      var data = p.data() as Map<String, dynamic>;
      String cid = data['categoryId'];
      double avg = 0;
      int cnt = 0;

      final rSnap = await FirebaseFirestore.instance
          .collection('ratings')
          .where('productId', isEqualTo: data['productId'])
          .get();

      cnt = rSnap.size;
      if (cnt > 0) {
        avg = rSnap.docs.map((d) => d['rating'] as num).reduce((a, b) => a + b) / cnt;
      }

      temp.add({
        'data': data,
        'rating': avg,
        'ratingCount': cnt,
        'categoryName': catMap[cid] ?? 'Unknown',
      });
    }

    setState(() {
      _products = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> display = [..._products];

    // Apply search filter by product name or category
    if (_searchQuery.isNotEmpty) {
      display = display.where((item) {
        final name = item['data']['productName'].toString().toLowerCase();
        final catName = item['categoryName'].toString().toLowerCase();
        return name.contains(_searchQuery) || catName.contains(_searchQuery);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      display = display.where((item) => item['categoryName'] == _selectedCategory).toList();
    }

    // Apply sort
    switch (_sortOption) {
      case 'Price: Low to High':
        display.sort((a, b) =>
            int.parse(a['data']['productPrice']).compareTo(int.parse(b['data']['productPrice'])));
        break;
      case 'Price: High to Low':
        display.sort((a, b) =>
            int.parse(b['data']['productPrice']).compareTo(int.parse(a['data']['productPrice'])));
        break;
      case 'Rating: High to Low':
        display.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                User_Heading(title: 'Laptops'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Products or Categories',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim().toLowerCase();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: _buildCategoryDropdown()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSortDropdown()),
                    ],
                  ),
                ),
                Expanded(
                  child: display.isEmpty
                      ? const Center(child: Text('No products found.'))
                      : ListView.builder(
                          itemCount: display.length,
                          itemBuilder: (ctx, i) {
                            final prod = display[i];
                            final data = prod['data'] as Map<String, dynamic>;
                            final avg = prod['rating'] as double;
                            final cnt = prod['ratingCount'] as int;
                            final catName = prod['categoryName'] as String;
                            final img = base64Decode(data['productImage']);

                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(img,
                                          width: 100, height: 100, fit: BoxFit.cover),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data['productName'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text(catName,
                                              style: const TextStyle(color: Colors.grey)),
                                          const SizedBox(height: 6),
                                          Row(children: [
                                            const Icon(Icons.star,
                                                size: 16, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Text(avg.toStringAsFixed(1)),
                                            const SizedBox(width: 6),
                                            Text('($cnt) Reviews',
                                                style: const TextStyle(color: Colors.grey)),
                                          ]),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Rs ${data['productPrice']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.green)),
                                              MyButton(
                                                title: 'Details',
                                                height: 40,
                                                onPressed: () =>
                                                    Get.to(ProductDetail(productData: data)),
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
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      value: _selectedCategory,
      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: (v) => setState(() => _selectedCategory = v!),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Sort',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      value: _sortOption,
      items: const [
        'None',
        'Price: Low to High',
        'Price: High to Low',
        'Rating: High to Low'
      ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: (v) => setState(() => _sortOption = v!),
    );
  }
}
