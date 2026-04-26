import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_state.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/manager/track_order_view_model.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_content.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_loading_view.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: l10n.track_order,
        backgroundColor: color.surface,
      ),
      body: BlocConsumer<TrackOrderViewModel, TrackOrderState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure &&
            current.failure != null &&
            previous.orderTracking != null,
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;

          CustomSnackbar.showError(
            context: context,
            message: failure.errorMessage,
          );
        },
        builder: (context, state) {
          if (state.isLoading && state.orderTracking == null) {
            return const TrackOrderLoadingView();
          }

          if (state.failure != null && state.orderTracking == null) {
            return ApiErrorWidget(
              exception: state.failure!.exception,
              onRetry: () => context.read<TrackOrderViewModel>().load(),
            );
          }

          final tracking = state.orderTracking;
          if (tracking == null) {
            return const SizedBox.shrink();
          }

          return TrackOrderContent(orderId: orderId, tracking: tracking);
        },
      ),
    );
  }
}
