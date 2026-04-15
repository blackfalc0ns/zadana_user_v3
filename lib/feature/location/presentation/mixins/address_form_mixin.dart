import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';

mixin AddressFormMixin<T extends StatefulWidget> on State<T> {
  Map<String, String> get labelOptions => {
    context.localization.location_address_label_home: 'Home',
    context.localization.location_address_label_work: 'Work',
    context.localization.location_address_label_other: 'Other',
  };

  String? selectedLabel;

  void initializeLabel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<LocationViewModel>().state;

      if (state.label.isEmpty) {
        selectedLabel = context.localization.location_address_label_home;
        context.read<LocationViewModel>().doIntent(
          const UpdateLabelEvent('Home'),
        );
      } else {
        final labelEntry = labelOptions.entries.firstWhere(
          (entry) => entry.value == state.label,
          orElse: () => MapEntry(
            context.localization.location_address_label_home,
            'Home',
          ),
        );
        selectedLabel = labelEntry.key;
      }
    });
  }

  void onLabelChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedLabel = newValue;
      });

      final stringValue = labelOptions[newValue]!;
      context.read<LocationViewModel>().doIntent(UpdateLabelEvent(stringValue));
    }
  }

  void showLabelError() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: InlineApiErrorWidget(
          failure: Failure(
            errorMessage: context.localization.location_address_label_required,
            code: 'error_validation',
          ),
          onRetry: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );
  }

  bool validateLabel() => selectedLabel != null;
}
