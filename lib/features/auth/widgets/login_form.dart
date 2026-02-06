import 'package:flutter/material.dart';
import 'package:latihan_ui/features/auth/components/login_header.dart';
import 'package:latihan_ui/features/auth/components/email_field.dart';
import 'package:latihan_ui/features/auth/components/password_field.dart';
import 'package:latihan_ui/features/auth/components/login_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoginHeader(),
          const EmailField(),
          const SizedBox(height: 16),
          const PasswordField(),
          const SizedBox(height: 24),
          const LoginButton(),
        ],
      ),
    );
  }
}
