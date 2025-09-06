import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:laptop_harbor/DesignerPanel/DashboardScreen.dart';
import 'package:laptop_harbor/DesignerPanel/ProfileScreen.dart';
import 'package:laptop_harbor/DesignerPanel/designerPorfolio.dart';


class DesignerHomeScreen extends StatefulWidget {
  const DesignerHomeScreen({Key? key}) : super(key: key);

  @override
  State<DesignerHomeScreen> createState() => _DesignerHomeScreenState();
}

class _DesignerHomeScreenState extends State<DesignerHomeScreen> {
  int _currentIndex = 0;
  late String designerId;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();

    // Ensure EasyLoading Overlay exists
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   EasyLoading.show(status: 'Loading...');
    //   Future.delayed(const Duration(seconds: 1), () => EasyLoading.dismiss());
    // });

    // Get current logged-in designer UID
    designerId = FirebaseAuth.instance.currentUser?.uid ?? 'demoUID';

    // Initialize tabs/screens
    screens = [
       Dashboardscreen(),
      Center(child: Text("Bookings")),
      DesignerPortfolioScreen(designerId: designerId),
    
      DesignerProfile()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Portfolio'),
        
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Designer Dashboard'), centerTitle: true),
      body: const Center(child: Text("Dashboard Stats Here")),
    );
  }
}