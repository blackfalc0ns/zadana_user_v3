import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';

class BuildingFormFields extends StatelessWidget {
  const BuildingFormFields({
    super.key,
    required this.buildingController,
    required this.floorController,
    required this.apartmentController,
  });
  final TextEditingController buildingController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final iconColor = color.onSurfaceVariant.withValues(alpha: 0.7);
    final hintStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: color.onSurfaceVariant.withValues(alpha: 0.8),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBuildingField(context, iconColor, hintStyle),
        const SizedBox(height: Spacing.lg),
        _buildFloorField(context, iconColor, hintStyle),
        const SizedBox(height: Spacing.lg),
        _buildApartmentField(context, iconColor, hintStyle),
      ],
    );
  }

  Widget _buildBuildingField(
    BuildContext context,
    Color iconColor,
    TextStyle? hintStyle,
  ) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(
          context,
          l10n.location_building_number_label,
        ),
        AppTextField(
          controller: buildingController,
          hint: l10n.location_building_number_hint,
          hintStyle: hintStyle,
          prefixIcon: Icon(Iconsax.building, color: iconColor, size: 24),
          validator: (value) => value?.trim().isEmpty == true
              ? l10n.location_building_number_required
              : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateBuildingNoEvent(value),
          ),
        ),
      ],
    );
  }

  Widget _buildFloorField(
    BuildContext context,
    Color iconColor,
    TextStyle? hintStyle,
  ) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(
          context,
          l10n.location_floor_number_label,
        ),
        AppTextField(
          controller: floorController,
          hint: l10n.location_floor_number_hint,
          hintStyle: hintStyle,
          prefixIcon: Icon(Iconsax.buildings, color: iconColor, size: 24),
          keyboardType: TextInputType.number,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateFloorNoEvent(value),
          ),
        ),
      ],
    );
  }

  Widget _buildApartmentField(
    BuildContext context,
    Color iconColor,
    TextStyle? hintStyle,
  ) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(
          context,
          l10n.location_apartment_number_label,
        ),
        AppTextField(
          controller: apartmentController,
          hint: l10n.location_apartment_number_hint,
          hintStyle: hintStyle,
          prefixIcon: Icon(Iconsax.home, color: iconColor, size: 24),
          keyboardType: TextInputType.number,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateApartmentNoEvent(value),
          ),
        ),
      ],
    );
  }
}
