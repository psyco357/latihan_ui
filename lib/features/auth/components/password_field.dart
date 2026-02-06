import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controllers/auth_controller.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = context.watch<AuthController>();

    return TextField(
      // controller: controller.passwordController,
      // obscureText: controller.obscurePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        // suffixIcon: IconButton(
        // icon: Icon(
        // controller.obscurePassword
        //     ? Icons.visibility_off:
        // Icons.visibility,
        // ),
        // onPressed: controller.toggleObscurePassword,
        // ),
        labelText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
