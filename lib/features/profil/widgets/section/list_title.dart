import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

      leading: Icon(
        icon,
        size: 24,
        color: colors.primary, // 🔥 ikut theme
      ),

      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(
          color: colors.onSurface, // 🔥 kontras otomatis
        ),
      ),

      trailing:
          trailing ??
          Icon(
            CupertinoIcons.chevron_right,
            color: colors.onSurfaceVariant, // 🔥 bukan grey
            size: 20,
          ),

      onTap: onTap,
    );
  }
}
