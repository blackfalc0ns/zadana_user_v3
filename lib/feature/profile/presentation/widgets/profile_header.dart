import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String? avatarUrl;
  final VoidCallback onSettingsTap;
  final VoidCallback? onTap;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.onSettingsTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(Spacing.cardRadius),
        bottomRight: Radius.circular(Spacing.cardRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(Spacing.base),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(Spacing.cardRadius),
            bottomRight: Radius.circular(Spacing.cardRadius),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: Spacing.avatarLg / 2,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Icon(
                      Icons.person,
                      size: Spacing.iconXl,
                      color: colorScheme.primary,
                    )
                  : null,
            ),

            const SizedBox(width: Spacing.md),

            // Name & Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    email,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Settings Icon
            IconButton(
              onPressed: onSettingsTap,
              icon: const Icon(Icons.settings_outlined),
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
