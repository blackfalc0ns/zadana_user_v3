import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

class PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHelpPressed;

  const PaymentAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return AppBar(
      title: Text(
        title,
        style: getBoldStyle(
          fontSize: FontSize.size18,
          fontFamily: FontConstant.cairo,
          color: colors.onSurface,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _AppBarIconButton(
        icon: Icons.arrow_back_ios,
        onPressed: onBackPressed ?? () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
      ),
      actions: [
        _AppBarIconButton(
          icon: Icons.help_outline,
          onPressed: onHelpPressed ?? () {
            HapticFeedback.lightImpact();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AppBarIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: colors.onSurface, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
