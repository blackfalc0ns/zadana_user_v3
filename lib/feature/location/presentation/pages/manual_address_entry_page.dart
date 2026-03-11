import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/mixins/address_form_mixin.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/building_form_fields.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/manual_address_fields.dart';

class ManualAddressEntryPage extends StatelessWidget {
  const ManualAddressEntryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<LocationViewModel>(), child: const _ManualAddressEntryView());
  }
}

class _ManualAddressEntryView extends StatefulWidget {
  const _ManualAddressEntryView();
  @override
  State<_ManualAddressEntryView> createState() => _ManualAddressEntryViewState();
}

class _ManualAddressEntryViewState extends State<_ManualAddressEntryView> with AddressFormMixin {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<LocationViewModel>().state;
      _addressController.text = state.addressLine;
      _cityController.text = state.city;
      _areaController.text = state.area;
      _buildingController.text = state.buildingNo;
      _floorController.text = state.floorNo;
      _apartmentController.text = state.apartmentNo;
    });
    initializeLabel();
  }

  @override
  void dispose() {
    [_addressController, _cityController, _areaController, 
     _buildingController, _floorController, _apartmentController]
        .forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate() || !validateLabel()) {
      if (!validateLabel()) showLabelError();
      return;
    }
    final viewModel = context.read<LocationViewModel>();
    final manualLocation = LocationEntity(
      addressLine: _addressController.text.trim(), city: _cityController.text.trim(),
      area: _areaController.text.trim(), latitude: 0.0, longitude: 0.0,
      buildingNo: _buildingController.text.trim(), floorNo: _floorController.text.trim(),
      apartmentNo: _apartmentController.text.trim(), label: viewModel.state.label,
    );
    viewModel.doIntent(SetSelectedLocationEvent(manualLocation));
    Navigator.pop<LocationEntity>(context, manualLocation);
  }

  @override
  Widget build(BuildContext context) {
    return AddressFormPage(
      title: 'إدخال العنوان يدوياً', confirmButtonText: 'تأكيد العنوان',
      isLoading: false, onConfirm: _onConfirm,
      formContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('أدخل تفاصيل عنوانك', style: AppTextStyles.h2),
              const SizedBox(height: Spacing.sm),
              Text('املأ البيانات التالية لإضافة عنوانك الجديد',
                   style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: Spacing.xl),
              ManualAddressFields(
                addressController: _addressController, cityController: _cityController,
                areaController: _areaController,
              ),
              const SizedBox(height: Spacing.lg),
              BuildingFormFields(
                buildingController: _buildingController, floorController: _floorController,
                apartmentController: _apartmentController,
              ),
              const SizedBox(height: Spacing.lg),
              AddressFormWidgets.buildFieldLabel('تسمية العنوان *'),
              AddressFormWidgets.buildLabelDropdown(
                selectedLabel: selectedLabel, labelOptions: labelOptions, onChanged: onLabelChanged,
              ),
              const SizedBox(height: Spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}