import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';

class AddressFormPage extends StatelessWidget {
  final String title;
  final Widget formContent;
  final bool isLoading;
  final VoidCallback onConfirm;
  final String confirmButtonText;

  const AddressFormPage({
    super.key,
    required this.title,
    required this.formContent,
    required this.isLoading,
    required this.onConfirm,
    required this.confirmButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
      ),
      body: BlocBuilder<LocationViewModel, LocationState>(
        builder: (context, state) {
          final showGlobalError = !state.isLoading && state.failure != null;

          if (showGlobalError) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.screenH),
                child: ApiErrorWidget.fromFailure(
                  state.failure!,
                  onRetry: context.read<LocationViewModel>().clearFeedback,
                  onGoBack: () => Navigator.pop(context),
                ),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(child: formContent),
                AddressFormWidgets.buildConfirmButton(
                  isLoading: state.isLoading,
                  onPressed: onConfirm,
                  text: confirmButtonText,
                  context: context,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
