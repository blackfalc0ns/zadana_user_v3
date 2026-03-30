import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';

class BuildingFormFields extends StatelessWidget {
  final TextEditingController buildingController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;

  const BuildingFormFields({
    super.key,
    required this.buildingController,
    required this.floorController,
    required this.apartmentController,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBuildingField(context, color.outline.withValues(alpha: 0.3)),
        const SizedBox(height: Spacing.lg),
        _buildFloorField(context, color.outline.withValues(alpha: 0.3)),
        const SizedBox(height: Spacing.lg),
        _buildApartmentField(context, color.outline.withValues(alpha: 0.3)),
      ],
    );
  }

  Widget _buildBuildingField(BuildContext context, Color color) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel('رقم المبنى *'),
        AppTextField(
          controller: buildingController,
          hint: 'مثال: 15',
          prefixIcon: Icon(Iconsax.building, color: color),
          validator: (value) =>
              value?.trim().isEmpty == true ? 'رقم المبنى مطلوب' : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateBuildingNoEvent(value),
          ),
        ),
      ],
    );
  }

  Widget _buildFloorField(BuildContext context, Color color ) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel('رقم الطابق'),
        AppTextField(
          controller: floorController,
          hint: 'مثال: 3',
          prefixIcon: Icon(Iconsax.buildings, color: color),
          keyboardType: TextInputType.number,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateFloorNoEvent(value),
          ),
        ),
      ],
    );
  }

  Widget _buildApartmentField(BuildContext context, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel('رقم الشقة'),
        AppTextField(
          controller: apartmentController,
          hint: 'مثال: 5',
          prefixIcon: Icon(Iconsax.home, color: color),
          keyboardType: TextInputType.number,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(
            UpdateApartmentNoEvent(value),
          ),
        ),
      ],
    );
  }
}
