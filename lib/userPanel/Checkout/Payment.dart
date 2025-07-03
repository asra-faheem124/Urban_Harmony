import 'package:flutter/material.dart';

class Payment extends StatelessWidget {
  final VoidCallback onConfirm;

  const Payment({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Center(
              child: Text(
                "Payemnt Method",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/google.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // spacing between avatar and text
                  Expanded(
                    child: Text(
                      "Google Pay",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.circle_outlined)),
                ],
              ),
            ),
            SizedBox(height: 20), // spacing between rows
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ClipOval(
                        child: Center(
                          child: Text(
                            "COD",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Cash On Delivery",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.circle_outlined)),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/easypaisa.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "EasyPaisa",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.circle_outlined)),
                ],
              ),
            ),
            Center(
              child: Container(
                width: 360,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Card Holder name',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Easy Paisa Number',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: onConfirm,
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,)
                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
