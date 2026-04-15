import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key, required this.onStartShopping});
  final VoidCallback onStartShopping;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStateWidget(
              title: locale.favorites_empty,
              description: locale.favorites_empty_message,
              icon: Icons.favorite_border_rounded,
            ),
            const SizedBox(height: Spacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xxxl),
              child: AppButton(
                onPressed: onStartShopping,
                text: locale.start_shopping,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
