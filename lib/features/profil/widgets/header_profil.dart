import 'package:flutter/material.dart';

class HeaderProfil extends StatelessWidget {
  final String username;

  const HeaderProfil({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          username,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '@$username',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
