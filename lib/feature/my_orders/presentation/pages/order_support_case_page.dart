import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_sheets.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_support_case_sections.dart';

class OrderSupportCasePage extends StatelessWidget {
  const OrderSupportCasePage({
    super.key,
    required this.orderId,
    this.initialCaseId,
  });

  final String orderId;
  final String? initialCaseId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.my_orders_support_case_title),
      body: BlocConsumer<OrderSupportCaseViewModel, OrderSupportCaseState>(
        listenWhen: (previous, current) =>
            previous.feedbackMessage != current.feedbackMessage,
        listener: (context, state) {
          final feedback = state.feedbackMessage;
          if (feedback == null || feedback.isEmpty) return;
          if (state.isFeedbackError) {
            CustomSnackbar.showError(context: context, message: feedback);
          } else {
            CustomSnackbar.showSuccess(context: context, message: feedback);
          }
          context.read<OrderSupportCaseViewModel>().clearFeedback();
        },
        builder: (context, state) {
          final isInitialLoading =
              (state.isLoading || state.isCaseLoading) &&
              state.selectedCase == null;

          if (isInitialLoading) {
            return const CustomProgressIndicator();
          }

          if (state.failure != null && state.items.isEmpty) {
            return ApiErrorWidget(
              exception: state.failure!.exception,
              onRetry: () => context.read<OrderSupportCaseViewModel>().refresh(
                initialCaseId: initialCaseId,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<OrderSupportCaseViewModel>().refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Spacing.base),
              children: [
                if (state.isCaseLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: Spacing.lg),
                    child: CustomProgressIndicator(size: 56),
                  )
                else if (state.selectedCase != null)
                  OrderSupportCaseDetailsView(
                    orderSupportCase: state.selectedCase!,
                    isSendingMessage: state.isSendingMessage,
                    onSendMessage: state.selectedCase!.canSendMessage
                        ? () async {
                            final result = await showOrderSupportMessageSheet(
                              context: context,
                            );
                            if (result == null || !context.mounted) return;
                            await context
                                .read<OrderSupportCaseViewModel>()
                                .sendMessage(
                                  state.selectedCase!.id,
                                  message: result.message,
                                  attachmentPaths: result.attachments
                                      .map((item) => item.path ?? '')
                                      .toList(growable: false),
                                );
                          }
                        : null,
                  )
                else
                  DetailSection(
                    title: l10n.my_orders_support_case_details_title,
                    child: SecondaryText(
                      l10n.my_orders_support_case_empty_details,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
