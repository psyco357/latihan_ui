import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/state_theme.dart';
import 'section/section.dart';
import 'section/list_title.dart';

class SettingSection extends StatelessWidget {
  const SettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<StateTheme>();
    return Column(
      children: [
        SettingGroup(
          title: "General",
          children: [
            const SettingTile(
              title: "About Phone",
              icon: CupertinoIcons.device_phone_portrait,
            ),
            SettingTile(
              title: theme.isDark ? "Dark Mode" : "Light Mode",
              icon: theme.isDark
                  ? CupertinoIcons.moon_fill
                  : CupertinoIcons.sun_max_fill,
              trailing: CupertinoSwitch(
                value: theme.isDark,
                onChanged: theme.toggleTheme,
              ),
            ),
            const SettingTile(
              title: "System Apps Updater",
              icon: CupertinoIcons.cloud_download,
            ),
            const SettingTile(
              title: "Security Status",
              icon: CupertinoIcons.lock_shield,
            ),
          ],
        ),
      ],
    );
  }
}
