import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';

class BuildingFormFields extends StatefulWidget {
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
  State<BuildingFormFields> createState() => _BuildingFormFieldsState();
}

class _BuildingFormFieldsState extends State<BuildingFormFields> {
  final _buildingFocus = FocusNode();
  final _floorFocus = FocusNode();
  final _apartmentFocus = FocusNode();

  @override
  void dispose() {
    _buildingFocus.dispose();
    _floorFocus.dispose();
    _apartmentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final iconColor = color.onSurfaceVariant.withValues(alpha: 0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBuildingField(context, iconColor),
        const SizedBox(height: Spacing.lg),
        _buildFloorField(context, iconColor),
        const SizedBox(height: Spacing.lg),
        _buildApartmentField(context, iconColor),
      ],
    );
  }

  Widget _buildBuildingField(BuildContext context, Color iconColor) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(
          context,
          l10n.location_building_number_label,
        ),
        AppTextField(
          controller: widget.buildingController,
          focusNode: _buildingFocus,
          hint: l10n.location_building_number_hint,
          prefixIcon: Icon(Iconsax.building, color: iconColor, size: 24),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validator: (value) => value?.trim().isEmpty == true
              ? l10n.location_building_number_required
              : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateBuildingNoEvent(value),
          ),
          onSubmitted: (_) => _floorFocus.requestFocus(),
        ),
      ],
    );
  }

  Widget _buildFloorField(BuildContext context, Color iconColor) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(
          context,
          l10n.location_floor_number_label,
        ),
        AppTextField(
          controller: widget.floorController,
          focusNode: _floorFocus,
          hint: l10n.location_floor_number_hint,
          prefixIcon: Icon(Iconsax.buildings, color: iconColor, size: 24),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateFloorNoEvent(value),
          ),
          onSubmitted: (_) => _apartmentFocus.requestFocus(),
        ),
      ],
    );
  }

  Widget _buildApartmentField(BuildContext context, Color iconColor) {
    final l10n = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel(
          context,
          l10n.location_apartment_number_label,
        ),
        AppTextField(
          controller: widget.apartmentController,
          focusNode: _apartmentFocus,
          hint: l10n.location_apartment_number_hint,
          prefixIcon: Icon(Iconsax.home, color: iconColor, size: 24),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateApartmentNoEvent(value),
          ),
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}
