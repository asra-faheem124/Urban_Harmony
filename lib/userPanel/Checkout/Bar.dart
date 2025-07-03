import 'package:flutter/material.dart';
import 'package:laptop_harbor/userPanel/Checkout/Review.dart';
import 'Shipping.dart';
import 'Payment.dart';

void main() => runApp(const MaterialApp(home: StepperUI()));

class StepperUI extends StatefulWidget {
  const StepperUI({super.key});

  @override
  State<StepperUI> createState() => _StepperUIState();
}

class _StepperUIState extends State<StepperUI> {
  int currentIndex = 0;

  void goToStep(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final steps = ['Shipping', 'Payment', 'Review'];
  final icons = [Icons.local_shipping, Icons.payment, Icons.assignment_turned_in];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Steps'),
        centerTitle: true,
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
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// Step Indicator Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(steps.length, (index) {
              return Row(
                children: [
                  InkWell(
                    onTap: () => goToStep(index),
                    child: Column(
                      children: [
                        Icon(
                          icons[index],
                          color: currentIndex == index ? Colors.black : Colors.grey,
                        ),
                        Text(
                          steps[index],
                          style: TextStyle(
                            color: currentIndex == index ? Colors.black : Colors.grey,
                            fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (index != steps.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.horizontal_rule, color: Colors.grey),
                    )
                ],
              );
            }),
          ),

          const SizedBox(height: 20),

          /// Page Content
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: [
                Shipping(
                  onConfirm: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                ),
                Payment(onConfirm: (){
                  setState(() {
                    currentIndex = 2;
                  });
                },),
              Review() // Placeholder
              ],
            ),
          ),
        ],
      ),
    );
  }
}
