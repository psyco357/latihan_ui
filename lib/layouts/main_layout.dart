import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/button_navigation.dart';
import '../../pages/dashboard_page.dart';
import '../../pages/profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [DashboardPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.blue, // 🔥 warna background
        statusBarIconBrightness: Brightness.light, // Android
        statusBarBrightness: Brightness.dark, // iOS
      ),
      child: Scaffold(
        body: SafeArea(
          // 🔥 biar aman notch
          child: _pages[_currentIndex],
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
