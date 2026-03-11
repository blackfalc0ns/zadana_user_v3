import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

/// Reusable section with header and content
class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: title,
          actionLabel: actionLabel ?? '',
          onActionTap: onActionTap,
        ),
        const SizedBox(height: Spacing.md),
        child,
      ],
    );
  }
}
