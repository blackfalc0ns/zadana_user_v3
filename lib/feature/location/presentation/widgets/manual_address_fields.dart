import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';

class ManualAddressFields extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController areaController;

  const ManualAddressFields({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.areaController,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel('العنوان التفصيلي *'),
        AppTextField(
          controller: addressController,
          hint: 'مثال: شارع الجمهورية، بجوار مسجد النور',
          keyboardType: TextInputType.streetAddress,
          validator: (value) => value?.trim().isEmpty == true ? 'العنوان التفصيلي مطلوب' : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(UpdateManualAddressEvent(value)),
        ),
      ],
    );
  }

  Widget _buildCityField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel('المدينة *'),
        AppTextField(
          controller: cityController,
          hint: 'مثال: القاهرة',
          validator: (value) => value?.trim().isEmpty == true ? 'المدينة مطلوبة' : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(UpdateCityEvent(value)),
        ),
      ],
    );
  }

  Widget _buildAreaField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressFormWidgets.buildFieldLabel('المنطقة *'),
        AppTextField(
          controller: areaController,
          hint: 'مثال: المعادي',
          validator: (value) => value?.trim().isEmpty == true ? 'المنطقة مطلوبة' : null,
          onChanged: (value) => context.read<LocationViewModel>().doIntent(UpdateAreaEvent(value)),
        ),
      ],
    );
  }
}