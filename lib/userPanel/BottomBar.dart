import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laptop_harbor/userPanel/Cart.dart';
import 'package:laptop_harbor/userPanel/Home.dart';
import 'package:laptop_harbor/userPanel/Profile.dart';
import 'package:laptop_harbor/userPanel/product.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  final User? user = FirebaseAuth.instance.currentUser;

  final List<Widget> loggedInPages = [
    HomeScreen(),
    ProductsScreen(),
    Cart(),
    Center(child: Text("Favorites")),
    Profile(),
  ];

  final List<Widget> guestPages = [
    HomeScreen(),
    ProductsScreen(),
    _notLoggedInWidget(),
    _notLoggedInWidget(),
    _notLoggedInWidget(),
  ];

  static Widget _notLoggedInWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 50,
            child: Icon(Icons.person_add_disabled_outlined, color: Colors.white, size: 40,),
          ),
          SizedBox(height: 15,),
          Text(
        "You are not logged in",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
        ],
      )
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = user != null ? loggedInPages : guestPages;

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 102, 99, 99),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wish List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
