import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/mixins/address_form_mixin.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/building_form_fields.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/manual_address_fields.dart';

class ManualAddressEntryPage extends StatelessWidget {
  const ManualAddressEntryPage({super.key, this.initialLocation});

  final LocationEntity? initialLocation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final vm = getIt<LocationViewModel>();
        if (initialLocation != null) {
          vm.doIntent(SetSelectedLocationEvent(initialLocation!));
        }
        return vm;
      },
      child: _ManualAddressEntryView(initialLocation: initialLocation),
    );
  }
}

class _ManualAddressEntryView extends StatefulWidget {
  const _ManualAddressEntryView({this.initialLocation});

  final LocationEntity? initialLocation;

  @override
  State<_ManualAddressEntryView> createState() =>
      _ManualAddressEntryViewState();
}

class _ManualAddressEntryViewState extends State<_ManualAddressEntryView>
    with AddressFormMixin {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();

  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLocation?.latitude;
    _longitude = widget.initialLocation?.longitude;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<LocationViewModel>().state;
      _addressController.text = state.addressLine;
      _cityController.text = state.city;
      _areaController.text = state.area;
      _buildingController.text = state.buildingNo;
      _floorController.text = state.floorNo;
      _apartmentController.text = state.apartmentNo;
      if (_latitude == null || _latitude == 0.0) {
        _latitude = state.selectedLocation?.latitude;
      }
      if (_longitude == null || _longitude == 0.0) {
        _longitude = state.selectedLocation?.longitude;
      }
    });
    initializeLabel();
  }

  @override
  void dispose() {
    for (final controller in [
      _addressController,
      _cityController,
      _areaController,
      _buildingController,
      _floorController,
      _apartmentController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate() || !validateLabel()) {
      if (!validateLabel()) showLabelError();
      return;
    }
    final viewModel = context.read<LocationViewModel>();
    final manualLocation = LocationEntity(
      addressLine: _addressController.text.trim(),
      city: _cityController.text.trim(),
      area: _areaController.text.trim(),
      latitude: _latitude ?? 0.0,
      longitude: _longitude ?? 0.0,
      buildingNo: _buildingController.text.trim(),
      floorNo: _floorController.text.trim(),
      apartmentNo: _apartmentController.text.trim(),
      label: viewModel.state.label,
    );
    viewModel.doIntent(SetSelectedLocationEvent(manualLocation));
    if (widget.initialLocation != null) {
      Navigator.pop<LocationEntity>(context, manualLocation);
      return;
    }

    Navigator.pop<LocationEntity>(context, manualLocation);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final isEditMode = widget.initialLocation != null;
    final color = context.colorScheme;

    return AddressFormPage(
      title: isEditMode
          ? l10n.location_edit_address_page_title
          : l10n.location_manual_address_page_title,
      confirmButtonText: isEditMode
          ? l10n.location_update_address
          : l10n.location_confirm_address,
      isLoading: false,
      onConfirm: _onConfirm,
      formContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode
                    ? l10n.location_edit_address_heading
                    : l10n.location_manual_address_heading,
                style: AppTextStyles.h2.copyWith(
                  color: color.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                isEditMode
                    ? l10n.location_edit_address_subtitle
                    : l10n.location_manual_address_subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              ManualAddressFields(
                addressController: _addressController,
                cityController: _cityController,
                areaController: _areaController,
              ),
              const SizedBox(height: Spacing.lg),
              BuildingFormFields(
                buildingController: _buildingController,
                floorController: _floorController,
                apartmentController: _apartmentController,
              ),
              const SizedBox(height: Spacing.lg),
              AddressFormWidgets.buildFieldLabel(
                context,
                l10n.location_address_label_title,
              ),
              AddressFormWidgets.buildLabelDropdown(
                context: context,
                selectedLabel: selectedLabel,
                labelOptions: labelOptions,
                onChanged: onLabelChanged,
              ),
              const SizedBox(height: Spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
