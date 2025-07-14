import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/controller/productController.dart';
import 'package:laptop_harbor/model/product_model.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AdminProductsPage extends StatelessWidget {
  Productcontroller productcontroller = Get.put(Productcontroller());
  Categorycontroller categorycontroller = Get.put(Categorycontroller());
  AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    categorycontroller.FetchCategory().then((_){
productcontroller.FetchProduct();
    });
    productcontroller.FetchProduct();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      title: Text('All Products', style: headingStyle,),
      ),
      body: Obx((){
        if(productcontroller.ProductList.isEmpty){
          return Center(child: Text('No Data Found'),);
        }
        return ListView.builder(itemCount: productcontroller.ProductList.length, itemBuilder: (context, index){
          ProductModel productModel = productcontroller.ProductList[index];
          Uint8List productImage = base64Decode(productModel.productImage);
          return Card(
            child: ListTile(
              leading: Image.memory(productImage, width: 100, height: 100, fit: BoxFit.cover,),
              title: Text(productModel.productName),
              subtitle: Text("${productModel.productDesc}\nRs.${productModel.productPrice}\nCategory: ${categorycontroller.CategoryMap[productModel.categoryId]}" ?? 'Unknown'),
              trailing: Wrap(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
                ],
              ),
            ),
          );
        });
      })
    );
  }
}
