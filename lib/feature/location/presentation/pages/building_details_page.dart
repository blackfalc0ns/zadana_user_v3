import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/mixins/address_form_mixin.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/building_form_fields.dart';

class BuildingDetailsPage extends StatelessWidget {
  final LocationEntity? initialLocation;
  const BuildingDetailsPage({super.key, this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final vm = getIt<LocationViewModel>();
        if (initialLocation != null) vm.doIntent(SetSelectedLocationEvent(initialLocation!));
        return vm;
      },
      child: const _BuildingDetailsView(),
    );
  }
}

class _BuildingDetailsView extends StatefulWidget {
  const _BuildingDetailsView();
  @override
  State<_BuildingDetailsView> createState() => _BuildingDetailsViewState();
}

class _BuildingDetailsViewState extends State<_BuildingDetailsView> with AddressFormMixin {
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
      if (!validateLabel()) showLabelError();
      return;
    }
    final viewModel = context.read<LocationViewModel>();
    final currentState = viewModel.state;
    final completeLocation = LocationEntity(
      addressLine: currentState.addressLine, city: currentState.city, area: currentState.area,
      latitude: currentState.selectedLocation?.latitude ?? 0.0,
      longitude: currentState.selectedLocation?.longitude ?? 0.0,
      buildingNo: currentState.buildingNo, floorNo: currentState.floorNo,
      apartmentNo: currentState.apartmentNo, label: currentState.label,
    );
    viewModel.doIntent(SetSelectedLocationEvent(completeLocation));
    Navigator.pushNamed(context, AppRoutes.signUp, arguments: completeLocation);
  }

  @override
  Widget build(BuildContext context) {
    return AddressFormPage(
      title: 'تفاصيل المبنى', confirmButtonText: 'متابعة للتسجيل',
      isLoading: false, onConfirm: _onConfirm,
      formContent: Form(
        key: _formKey,
        child: BlocBuilder<LocationViewModel, LocationState>(
          builder: (context, state) => SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.screenH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أدخل تفاصيل المبنى', style: AppTextStyles.h2),
                const SizedBox(height: Spacing.sm),
                Text('أضف تفاصيل المبنى والشقة لإكمال عنوانك', 
                     style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: Spacing.lg),
                if (state.selectedLocation != null) ...[
                  AddressFormWidgets.buildLocationDisplay(state.selectedLocation!.addressLine),
                  const SizedBox(height: Spacing.xl),
                ],
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
      ),
    );
  }
}