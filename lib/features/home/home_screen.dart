import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/consts/app_consts.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final role = 'reception';

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index, BuildContext context) {
    if (role != 'reception') return; // Only reception can navigate

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.pushReplacement('/patients');
        break;
      case 1:
        context.pushReplacement('/meds');
        break;
      case 2:
        context.pushReplacement('/report');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final int selectedIndex = _calculateSelectedIndex(context);

    // For non-reception roles, just show the child without navigation
    if (role != 'reception') {
      return Scaffold(
        appBar: AppBar(title: const Text(AppConstants.appName, style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
        body: widget.child,
      );
    }

    // Reception role gets the full navigation
    return Scaffold(
      appBar: AppBar(title:  const Text('إدارة المرضى', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'المرضى'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_information), label: 'الأدوية'), // Changed to history
          BottomNavigationBarItem(icon: Icon(Icons.request_page_outlined), label: 'التقرير'),
          // Removed medicines and records for reception
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
