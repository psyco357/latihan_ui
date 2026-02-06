import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo or Icon
        Container(
          padding: const EdgeInsets.all(16),
          // color: Colors.blue.shade50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade50,
          ),
          child: const Icon(Icons.lock_outline, size: 64, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        // title
        const Text(
          'Welcome Back',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // subtitle
        const Text(
          'Please login to your account',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
