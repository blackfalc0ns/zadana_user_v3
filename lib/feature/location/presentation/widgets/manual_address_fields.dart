import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';

class ManualAddressFields extends StatelessWidget {
  const ManualAddressFields({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.areaController,
  });
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController areaController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressField(context),
        const SizedBox(height: Spacing.lg),
        _buildCityField(context),
        const SizedBox(height: Spacing.lg),
        _buildAreaField(context),
      ],
    );
  }

  Widget _buildAddressField(BuildContext context) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(
          context,
          l10n.location_address_details_label,
        ),
        AppTextField(
          controller: addressController,
          hint: l10n.location_address_details_hint,
          keyboardType: TextInputType.streetAddress,
          validator: (value) => value?.trim().isEmpty == true
              ? l10n.location_address_details_required
              : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateManualAddressEvent(value),
          ),
        ),
      ],
    );
  }

  Widget _buildCityField(BuildContext context) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(context, l10n.location_city_label),
        AppTextField(
          controller: cityController,
          hint: l10n.location_city_hint,
          validator: (value) => value?.trim().isEmpty == true
              ? l10n.location_city_required
              : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateCityEvent(value),
          ),
        ),
      ],
    );
  }

  Widget _buildAreaField(BuildContext context) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(context, l10n.location_area_label),
        AppTextField(
          controller: areaController,
          hint: l10n.location_area_hint,
          validator: (value) => value?.trim().isEmpty == true
              ? l10n.location_area_required
              : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateAreaEvent(value),
          ),
        ),
      ],
    );
  }
}
