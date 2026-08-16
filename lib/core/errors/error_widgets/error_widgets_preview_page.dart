import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/errors/api_error_type.dart';
import 'package:zadana_user_v3/core/errors/api_exception.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:zadana_user_v3/core/network/failures.dart';

class ErrorWidgetsPreviewPage extends StatelessWidget {
  const ErrorWidgetsPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final samples = <_ErrorPreviewSample>[
      _ErrorPreviewSample(
        title: 'No internet',
        child: ApiErrorWidget(
          exception: _exception(ApiErrorType.noInternetConnection),
          onRetry: () {},
          onCheckConnection: () {},
        ),
      ),
      _ErrorPreviewSample(
        title: 'Connection timeout',
        child: ApiErrorWidget(
          exception: _exception(ApiErrorType.connectionTimeout),
          onRetry: () {},
        ),
      ),
      _ErrorPreviewSample(
        title: 'Server error',
        child: ApiErrorWidget(
          exception: _exception(ApiErrorType.internalServerError),
          onRetry: () {},
          onContactSupport: () {},
        ),
      ),
      _ErrorPreviewSample(
        title: 'Unauthorized client error',
        child: ApiErrorWidget(
          exception: _exception(ApiErrorType.unauthorized),
          onGoBack: () {},
        ),
      ),
      _ErrorPreviewSample(
        title: 'Too many requests',
        child: ApiErrorWidget(
          exception: _exception(ApiErrorType.tooManyRequests),
          onRetry: () {},
          onGoBack: () {},
        ),
      ),
      _ErrorPreviewSample(
        title: 'Location permission',
        child: ApiErrorWidget(
          exception: _exception(ApiErrorType.locationPermissionDeniedForever),
          onRetry: () {},
          onGoBack: () {},
        ),
      ),
      const _ErrorPreviewSample(
        title: 'Empty state',
        child: EmptyStateWidget(
          title: 'لا توجد بيانات حاليا',
          description: 'لما يكون المحتوى فاضي، الحالة دي بتظهر بدل مساحة بيضا.',
          icon: Icons.inbox_rounded,
        ),
      ),
      _ErrorPreviewSample(
        title: 'Inline no internet',
        child: InlineApiErrorWidget(
          failure: Failure(
            errorMessage: 'تعذر تحميل هذا الجزء بسبب انقطاع الاتصال.',
            code: 'error_no_internet',
          ),
          onRetry: () {},
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Error Widgets Preview')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: samples.length,
        separatorBuilder: (_, _) => const SizedBox(height: 18),
        itemBuilder: (context, index) => samples[index],
      ),
    );
  }

  static ApiException _exception(ApiErrorType type) {
    return ApiException(
      errorType: type,
      message: type.translationKey,
      isTranslationKey: true,
    );
  }
}

class _ErrorPreviewSample extends StatelessWidget {
  const _ErrorPreviewSample({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: SizedBox(height: 520, child: child),
        ),
      ],
    );
  }
}
