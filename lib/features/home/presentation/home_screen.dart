import 'package:flutter/material.dart';
import '../widgets/attendance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/menu_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bool hasCheckedIn = true;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const HomeHeader(),
            Positioned(
              bottom: hasCheckedIn ? -60 : -280,
              left: 15,
              right: 15,
              child: hasCheckedIn ? const AttendanceCard() : const MenuGrid(),
            ),
          ],
        ),

        // Spacer wajib biar konten berikutnya naik
        const SizedBox(height: hasCheckedIn ? 60 : 300),

        if (hasCheckedIn) const MenuGrid(),
      ],
    );
  }
}
