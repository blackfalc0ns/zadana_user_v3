import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/helpers/dialogue_utils.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';

class OrderDetailsDeleteAction extends StatelessWidget {
  const OrderDetailsDeleteAction({super.key, required this.targetOrderId});

  final String targetOrderId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OrderDetailsViewModel, OrderDetailsState>(
      buildWhen: (previous, current) =>
          previous.isDeleting != current.isDeleting ||
          previous.order?.canDelete != current.order?.canDelete,
      builder: (context, state) {
        if (!(state.order?.canDelete ?? false)) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: IconButton(
            tooltip: l10n.delete,
            onPressed: state.isDeleting
                ? null
                : () => _confirmDelete(
                    context: context,
                    targetOrderId: targetOrderId,
                  ),
            icon: state.isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                  ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete({
    required BuildContext context,
    required String targetOrderId,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await DialogueUtils.showCompactConfirmationDialog(
      context: context,
      title: l10n.my_orders_delete_title,
      message: l10n.my_orders_delete_message,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      icon: Icons.delete_outline_rounded,
      accentColor: AppColors.error,
    );

    if (!confirmed || !context.mounted) return;
    await context.read<OrderDetailsViewModel>().deleteOrder(targetOrderId);
  }
}
