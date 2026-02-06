// import '/constant/snackbar/snacktopbar.dart';
import 'package:flutter/material.dart';
import 'package:latihan_ui/layouts/main_layout.dart';
// import '../controllers/auth_controller.dart';
// import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = context.watch<AuthController>();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
          );
        },
        child: const Text('Login'),
      ),
    );
  }
}
