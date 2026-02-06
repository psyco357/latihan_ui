import 'package:flutter/material.dart';
import 'package:latihan_ui/features/profil/widgets/header_profil.dart';
import 'package:latihan_ui/features/profil/widgets/logout_button.dart';
import 'package:provider/provider.dart';
import '../widgets/setting_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, authProvider, _) {
                final username = 'user_demo';

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    HeaderProfil(username: username),
                    const SizedBox(height: 32),
                    const SettingSection(),
                    const SizedBox(height: 15),
                    LogoutButton(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
