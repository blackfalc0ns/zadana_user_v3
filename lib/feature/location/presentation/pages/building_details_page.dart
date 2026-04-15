import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/mixins/address_form_mixin.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/building_form_fields.dart';

class BuildingDetailsPage extends StatelessWidget {
  const BuildingDetailsPage({super.key, this.initialLocation});

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
      child: _BuildingDetailsView(initialLocation: initialLocation),
    );
  }
}

class _BuildingDetailsView extends StatefulWidget {
  const _BuildingDetailsView({this.initialLocation});

  final LocationEntity? initialLocation;

  @override
  State<_BuildingDetailsView> createState() => _BuildingDetailsViewState();
}

class _BuildingDetailsViewState extends State<_BuildingDetailsView>
    with AddressFormMixin {
  final _formKey = GlobalKey<FormState>();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<LocationViewModel>().state;
      _buildingController.text = state.buildingNo;
      _floorController.text = state.floorNo;
      _apartmentController.text = state.apartmentNo;
    });
    initializeLabel();
  }

  @override
  void dispose() {
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (!_formKey.currentState!.validate() || !validateLabel()) {
      if (!validateLabel()) {
        showLabelError();
      }
      return;
    }

    final viewModel = context.read<LocationViewModel>();
    final completeLocation = LocationEntity(
      addressLine: _resolveAddressLine(viewModel),
      city: _resolveCity(viewModel),
      area: _resolveArea(viewModel),
      latitude: viewModel.state.selectedLocation?.latitude ?? 0.0,
      longitude: viewModel.state.selectedLocation?.longitude ?? 0.0,
      buildingNo: _buildingController.text.trim(),
      floorNo: _floorController.text.trim(),
      apartmentNo: _apartmentController.text.trim(),
      label: viewModel.state.label,
    );

    viewModel.doIntent(SaveSelectedAddressEvent(completeLocation));
  }

  String _resolveAddressLine(LocationViewModel viewModel) {
    final current = viewModel.state.addressLine.trim();
    if (current.isNotEmpty) return current;
    return widget.initialLocation?.addressLine ?? '';
  }

  String _resolveCity(LocationViewModel viewModel) {
    final current = viewModel.state.city.trim();
    if (current.isNotEmpty) return current;
    return widget.initialLocation?.city ?? '';
  }

  String _resolveArea(LocationViewModel viewModel) {
    final current = viewModel.state.area.trim();
    if (current.isNotEmpty) return current;
    return widget.initialLocation?.area ?? '';
  }

  void _returnToMainShell() {
    if (mainShellKey.currentState != null) {
      Navigator.of(context).popUntil((route) {
        return route.settings.name == AppRoutes.mainShell || route.isFirst;
      });
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.mainShell,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;

    return BlocListener<LocationViewModel, LocationState>(
      listenWhen: (previous, current) =>
          previous.isAddressSaved != current.isAddressSaved,
      listener: (context, state) {
        if (state.isAddressSaved && !state.isLoading) {
          _returnToMainShell();
        }
      },
      child: AddressFormPage(
        title: l10n.location_building_details_page_title,
        confirmButtonText: l10n.location_save_address,
        isLoading: false,
        onConfirm: _onConfirm,
        formContent: Form(
          key: _formKey,
          child: BlocBuilder<LocationViewModel, LocationState>(
            builder: (context, state) => SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.screenH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.location_building_details_heading,
                    style: AppTextStyles.h2.copyWith(
                      color: color.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    l10n.location_building_details_subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: color.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  if (state.selectedLocation != null) ...[
                    AddressFormWidgets.buildLocationDisplay(
                      context,
                      state.selectedLocation!.addressLine,
                    ),
                    const SizedBox(height: Spacing.xl),
                  ],
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
        ),
      ),
    );
  }
}
