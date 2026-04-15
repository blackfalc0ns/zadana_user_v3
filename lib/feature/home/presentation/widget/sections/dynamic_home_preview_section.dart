import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/utils/main_shell_navigation.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_explore_more_entity.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/home_product_section_content.dart';

class DynamicHomePreviewSection extends StatelessWidget {
  const DynamicHomePreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (previous, current) =>
          previous.dynamicSection != current.dynamicSection,
      builder: (context, state) {
        if (state.dynamicSection.isLoading &&
            (state.dynamicSection.data?.isEmpty ?? true)) {
          return const Padding(
            padding: EdgeInsets.only(top: Spacing.xl),
            child: _DynamicSectionLoadingState(),
          );
        }

        final sections = (state.dynamicSection.data ?? const [])
            .where((section) => section.isActive && section.items.isNotEmpty)
            .toList(growable: false);

        if (sections.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: Spacing.xl),
          child: Column(
            children: [
              for (var i = 0; i < sections.length; i++) ...[
                _DynamicSectionBlock(section: sections[i]),
                if (i != sections.length - 1)
                  const SizedBox(height: Spacing.xl),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DynamicSectionLoadingState extends StatelessWidget {
  const _DynamicSectionLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _DynamicSectionSkeleton(titleWidth: 120, theme: 'theme1'),
        SizedBox(height: Spacing.xl),
        _DynamicSectionSkeleton(titleWidth: 100, theme: 'theme2'),
      ],
    );
  }
}

class _DynamicSectionSkeleton extends StatelessWidget {
  const _DynamicSectionSkeleton({
    required this.titleWidth,
    required this.theme,
  });

  final double titleWidth;
  final String theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: Row(
            children: [
              Bone(width: titleWidth, height: 14, radius: 999),
              const Spacer(),
              const Bone(width: 48, height: 12, radius: 999),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),
        ShimmerEffect(child: HomeProductSectionSkeleton(theme: theme)),
      ],
    );
  }
}

class _DynamicSectionBlock extends StatelessWidget {
  const _DynamicSectionBlock({required this.section});

  final HomeExploreMoreEntity section;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        SectionHeader(
          title: section.title,
          actionLabel: locale.see_all,
          onActionTap: () {
            CategoryNavigationService().setSelectedSubCategory(
              id: section.key,
              name: section.title,
            );
            openShoppingTab();
          },
        ),
        const SizedBox(height: Spacing.md),
        HomeProductSectionContent(
          items: section.items,
          theme: section.theme?.toString(),
          heroSource: 'dynamic-${section.key}',
        ),
      ],
    );
  }
}
