import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_progress_indicator.dart';

class AuthExperienceShell extends StatelessWidget {
  const AuthExperienceShell({
    super.key,
    required this.heroBadge,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.sectionTitle,
    required this.sectionDescription,
    required this.body,
    this.sectionBadge = 'Member',
    this.sectionIcon = Icons.lock_outline_rounded,
    this.footer,
    this.showBackButton = false,
    this.isLoading = false,
  });

  final String heroBadge;
  final String heroTitle;
  final String heroSubtitle;
  final String sectionTitle;
  final String sectionDescription;
  final String sectionBadge;
  final IconData sectionIcon;
  final Widget body;
  final Widget? footer;
  final bool showBackButton;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Scaffold(
      backgroundColor: color.surface,
      body: Stack(
        children: [
          const _AuthBackground(),
          AbsorbPointer(
            absorbing: isLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.base,
                  Spacing.base,
                  Spacing.base,
                  Spacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showBackButton) ...[
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: _AuthBackButton(
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                    ],
                    _HeroHeader(
                      badge: heroBadge,
                      title: heroTitle,
                      subtitle: heroSubtitle,
                    ),
                    const SizedBox(height: Spacing.sm),
                    _FormCard(
                      badge: sectionBadge,
                      title: sectionTitle,
                      description: sectionDescription,
                      icon: sectionIcon,
                      child: body,
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: Spacing.base),
                      Center(child: footer),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: ColoredBox(
                color: color.scrim.withValues(alpha: 0.18),
                child: const CustomProgressIndicator(size: 72),
              ),
            ),
        ],
      ),
    );
  }
}

class _AuthBackButton extends StatelessWidget {
  const _AuthBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.surfaceContainerLow.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconTheme(
            data: IconThemeData(size: 18, color: color.onSurface),
            child: const Center(child: Icon(Icons.arrow_back_ios_new_rounded)),
          ),
        ),
      ),
    );
  }
}

class AuthPromptText extends StatelessWidget {
  const AuthPromptText({
    super.key,
    required this.text,
    required this.actionLabel,
    required this.onTap,
  });

  final String text;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            text,
            style: getRegularStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                actionLabel,
                style: getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.badge,
    required this.title,
    required this.subtitle,
  });

  final String badge;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            color.primary,
            color.primary.withValues(alpha: 0.88),
            color.primaryContainer,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        fontSize: 20,
                        fontFamily: FontConstant.cairo,
                        color: color.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: getRegularStyle(
                        fontSize: 13,
                        fontFamily: FontConstant.cairo,
                        color: color.onPrimary.withValues(alpha: 0.92),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              const _HeroProduceArtwork(),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroProduceArtwork extends StatelessWidget {
  const _HeroProduceArtwork();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return SizedBox(
      width: 108,
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 8,
            left: 10,
            child: Container(
              width: 88,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    color.onPrimary.withValues(alpha: 0.16),
                    color.onPrimary.withValues(alpha: 0.06),
                  ],
                ),
                border: Border.all(
                  color: color.onPrimary.withValues(alpha: 0.10),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 6,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: color.onPrimary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned(
            top: 18,
            left: 0,
            child: _ProduceBox(
              assetPath: Assets.cabbage,
              size: 34,
              rotation: -0.22,
            ),
          ),
          const Positioned(
            top: 6,
            left: 32,
            child: _ProduceBox(
              assetPath: Assets.tomato,
              size: 40,
              rotation: -0.04,
            ),
          ),
          const Positioned(
            top: 22,
            right: 2,
            child: _ProduceBox(
              assetPath: Assets.chilli,
              size: 32,
              rotation: 0.20,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProduceBox extends StatelessWidget {
  const _ProduceBox({
    required this.assetPath,
    required this.size,
    this.rotation = 0,
  });

  final String assetPath;
  final double size;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color.onPrimary.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.onPrimary.withValues(alpha: 0.20)),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.badge,
    required this.title,
    required this.description,
    required this.icon,
    required this.child,
  });

  final String badge;
  final String title;
  final String description;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(Assets.logoDark, width: 100, height: 100),
          child,
        ],
      ),
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.alphaBlend(
                    color.primary.withValues(alpha: 0.05),
                    color.surface,
                  ),
                  color.surface,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: -20,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ],
    );
  }
}
