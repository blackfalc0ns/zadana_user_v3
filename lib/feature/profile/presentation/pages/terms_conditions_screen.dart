import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/shimmer_wrapper.dart';
import 'package:zadana_user_v3/feature/profile/data/legal_document_loader.dart';
import 'package:zadana_user_v3/feature/profile/data/models/legal_document_dto.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/legal_document_view.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) => LegalScreen(
    title: AppLocalizations.of(context)!.terms_conditions,
    documentType: 'CustomerTerms',
  );
}

class LegalScreen extends StatelessWidget {
  const LegalScreen({
    super.key,
    required this.title,
    required this.documentType,
  });

  final String title;
  final String documentType;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar(title: title),
      body: FutureBuilder<LegalDocumentDto>(
        future: LegalDocumentLoader.load(documentType),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LegalDocumentSkeleton();
          }
          final document = snapshot.data;
          final content = _pickContent(document, isArabic);
          if (snapshot.hasError || document == null || content.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.not_available),
            );
          }
          return Column(
            children: [
              _LegalMetadata(document: document, isArabic: isArabic),
              Expanded(
                child: LegalDocumentView(
                  content: content,
                  textDirection: isArabic
                      ? ui.TextDirection.rtl
                      : ui.TextDirection.ltr,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _pickContent(LegalDocumentDto? document, bool isArabic) {
    if (document == null) return '';
    final primary = (isArabic ? document.contentAr : document.contentEn).trim();
    if (primary.isNotEmpty) return primary;
    return (isArabic ? document.contentEn : document.contentAr).trim();
  }
}

class _LegalDocumentSkeleton extends StatelessWidget {
  const _LegalDocumentSkeleton();

  @override
  Widget build(BuildContext context) {
    final base = SkeletonColors.base(context);
    return ShimmerWrapper(
      isLoading: true,
      child: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              width: 128,
              height: 32,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(Spacing.sm),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xl),
          Container(width: 200, height: 26, color: base),
          const SizedBox(height: Spacing.xl),
          for (var index = 0; index < 5; index++) ...[
            Container(width: double.infinity, height: 16, color: base),
            const SizedBox(height: Spacing.sm),
            FractionallySizedBox(
              widthFactor: index.isEven ? .82 : .66,
              child: Container(height: 16, color: base),
            ),
            const SizedBox(height: Spacing.lg),
          ],
        ],
      ),
    );
  }
}

class _LegalMetadata extends StatelessWidget {
  const _LegalMetadata({required this.document, required this.isArabic});

  final LegalDocumentDto document;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final effectiveDate = document.effectiveAtUtc;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.lg, 0),
      child: Wrap(
        spacing: Spacing.sm,
        runSpacing: Spacing.sm,
        children: [
          _MetadataChip(
            label: '${isArabic ? 'الإصدار' : 'Version'} ${document.version}',
          ),
          if (effectiveDate != null)
            _MetadataChip(
              label:
                  '${isArabic ? 'ساري من' : 'Effective'} ${DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(effectiveDate.toLocal())}',
            ),
        ],
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Spacing.sm),
      ),
      child: Text(label, style: TextStyle(color: color.onSurfaceVariant)),
    );
  }
}
