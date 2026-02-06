import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latihan_ui/features/auth/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light, // ANDROID → icon putih
        statusBarBrightness: Brightness.dark, // iOS → icon putih
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.blue),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: const LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
