import 'package:flutter/material.dart';

class SettingGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingGroup({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION TITLE
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
          child: Text(
            title.toUpperCase(),
            style: textTheme.labelLarge?.copyWith(
              color: colors.onSurfaceVariant,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // GROUP CONTAINER
        Card(
          elevation: 0,
          color: colors.surface, // 🔥 adapt light/dark
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colors.outlineVariant, // 🔥 divider halus
            ),
          ),
          child: Column(
            children: _buildChildrenWithDividers(
              children,
              colors.outlineVariant,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers(
    List<Widget> children,
    Color dividerColor,
  ) {
    final List<Widget> result = [];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(Divider(height: 1, thickness: 1, color: dividerColor));
      }
    }
    return result;
  }
}
