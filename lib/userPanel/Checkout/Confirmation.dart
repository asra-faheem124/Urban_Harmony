import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/userPanel/TrackOrder.dart';
import 'package:laptop_harbor/userPanel/BottomBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';

class Confirmation extends StatelessWidget {
   final String orderId;
  const Confirmation({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
        
            children: [
              SizedBox(height: 100),
              Image.asset("assets/images/orderconfirm.png"),
              SizedBox(
                width: 400,
                child: Text(
                  "Your order has been placed successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: Text(
                  "Thank you for choosing us! Feel free to continue shopping and explore our wide range of products. Happy Shopping!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              MyButton(title: 'Continue Shopping', height: 50.0, onPressed: () => Get.offAll(BottomBar())),
              SizedBox(height: 20,),
                 MyButton(
        title: 'Track Order',
        height: 50.0,
        onPressed: () => Get.to(() => TrackOrderPage(orderId: orderId)),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
