import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/controller/productController.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';

class AddProduct extends StatefulWidget {
  AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  Categorycontroller categorycontroller = Get.put(Categorycontroller());
  Productcontroller productcontroller = Get.put(Productcontroller());
  final TextEditingController productName = TextEditingController();
  final TextEditingController productDesc = TextEditingController();
  final TextEditingController productPrice = TextEditingController();

  String? selectedCategory;
  ImagePicker imagePicker = ImagePicker();
  XFile? image;

  @override
  void initState(){
    super.initState();
    categorycontroller.FetchCategory();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name field
                        TextFormField(
                          controller: productName,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product name',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: productDesc,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product description',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: productPrice,
                          decoration: const InputDecoration(
                            hintText: 'Enter your product price',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        GestureDetector(
                          onTap: () async {
                            image = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey
                                )
                              ),
                              image:
                                  image != null
                                      ? DecorationImage(
                                        image: FileImage(File(image!.path)),
                                        fit: BoxFit.cover,
                                      )
                                      : null,
                            ),
                            alignment: Alignment.center,
                            child: image == null ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tap to upload an image')
                              ],
                            ) : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(image!.name)
                              ],
                            )
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Category Dropdown
                        Obx(() => DropdownButtonFormField(
                          value: selectedCategory,
                          items: categorycontroller.CategoryList.map((cat){
                            return DropdownMenuItem(child: Text(cat.categoryName), value: cat.categoryId,);
                          }).toList(), 
                          onChanged: (val){
                            setState(() {
                              selectedCategory = val;
                            });
                          },
                          decoration: InputDecoration(
                             hintText: 'Enter your product category',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          )),
                       
                        const SizedBox(height: 30),
                        // Submit button
                        Center(
                          child: MyButton(
                            title: 'Add',
                            onPressed: () async {
                              final imageFile = await image!.readAsBytes();
                              productcontroller.AddProduct(productName: productName.text.trim(), productDesc: productDesc.text.trim(), productPrice: productPrice.text.trim(), productImage: imageFile, productCategory: selectedCategory!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
