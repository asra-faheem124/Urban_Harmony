import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/add_category.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/model/category_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class AdminCategoryPage extends StatelessWidget {
  Categorycontroller categorycontroller = Get.put(Categorycontroller());
  AdminCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    categorycontroller.FetchCategory();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
           Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                          Admin_Heading(title: 'Categories'),
            MyButton(title: 'Add Category', onPressed: () => Get.to(AddCategoryPage())),
              ],
            ),
          ),
          Expanded(
            child: Obx((){
              if(categorycontroller.CategoryList.isEmpty){
                return Center(child: Text('No Data Found'),);
              }
              return ListView.builder(
  itemCount: categorycontroller.CategoryList.length,
  itemBuilder: (context, index) {
    CategoryModel categoryModel = categorycontroller.CategoryList[index];
    Uint8List categoryImage = base64Decode(categoryModel.categoryImage);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              categoryImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            categoryModel.categoryName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Wrap(
            spacing: 12,
            children: [
              Tooltip(
                message: "Edit Category",
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    // TODO: implement edit functionality
                    // You can show a bottom sheet or push to edit screen
                  },
                ),
              ),
              Tooltip(
                message: "Delete Category",
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: const Text("Are you sure you want to delete this category?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      // TODO: call your delete method from controller
                      // categorycontroller.deleteCategory(categoryModel.categoryId);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);

            }),
          ),
        ],
      )
    );
  }
}
