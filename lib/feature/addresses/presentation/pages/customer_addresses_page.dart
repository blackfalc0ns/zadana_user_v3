import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/api_error_type.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/services/cart_navigation_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/manager/customer_addresses_event.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/manager/customer_addresses_state.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/manager/customer_addresses_view_model.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/pages/customer_addresses_guest_page.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/widgets/customer_addresses_content.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/widgets/customer_addresses_loading_view.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/widgets/delete_address_dialog.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

class CustomerAddressesPage extends StatelessWidget {
  const CustomerAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CustomerAddressesViewModel>()
            ..doIntent(const CustomerAddressesLoadEvent()),
      child: const _CustomerAddressesView(),
    );
  }
}

class _CustomerAddressesView extends StatefulWidget {
  const _CustomerAddressesView();

  @override
  State<_CustomerAddressesView> createState() => _CustomerAddressesViewState();
}

class _CustomerAddressesViewState extends State<_CustomerAddressesView> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CustomerAddressesViewModel>().state;

    if (state.items.isEmpty && _isUnauthorizedFailure(state.failure)) {
      return const CustomerAddressesGuestPage();
    }

    final l10n = context.localization;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: CustomAppBar(title: l10n.addresses),
      body: BlocConsumer<CustomerAddressesViewModel, CustomerAddressesState>(
        listenWhen: (previous, current) =>
            previous.actionType != current.actionType ||
            previous.actionLabel != current.actionLabel ||
            previous.actionFailure != current.actionFailure,
        listener: _handleActionFeedback,
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const CustomerAddressesLoadingView();
          }

          if (state.failure != null && state.items.isEmpty) {
            return _AddressesErrorView(failure: state.failure!);
          }

          return CustomerAddressesContent(
            items: state.items,
            selectedDefaultId: state.selectedDefaultId,
            deletingAddressId: state.deletingAddressId,
            onSetDefault: _setDefaultAddress,
            onEdit: _editAddress,
            onDelete: _confirmDelete,
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: FilledButton.icon(
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.startSelectLocationPage, arguments: true),
          icon: const Icon(Icons.add_location_alt_outlined),
          label: Text(l10n.add_address),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: colors.onPrimary,
          ),
        ),
      ),
    );
  }

  bool _isUnauthorizedFailure(Failure? failure) {
    return failure?.exception.errorType == ApiErrorType.unauthorized;
  }

  void _handleActionFeedback(
    BuildContext context,
    CustomerAddressesState state,
  ) {
    final l10n = context.localization;
    final viewModel = context.read<CustomerAddressesViewModel>();

    if (state.actionType != null) {
      CustomSnackbar.showSuccess(
        context: context,
        message: _resolveActionMessage(l10n, state),
      );

      // Refresh cart data when the default address changes so that
      // branch-based availability is re-evaluated.
      if (state.actionType == CustomerAddressesActionType.setDefaultSuccess) {
        CartNavigationService().notifyTabChanged(reload: true);
      }

      viewModel.clearActionFeedback();
      return;
    }

    if (state.actionFailure != null) {
      CustomSnackbar.showError(
        context: context,
        message: state.actionFailure!.errorMessage,
      );
      viewModel.clearActionFeedback();
    }
  }

  void _setDefaultAddress(CustomerAddressEntity item) {
    context.read<CustomerAddressesViewModel>().doIntent(
      CustomerAddressSetDefaultEvent(item.id),
    );
  }

  void _editAddress(CustomerAddressEntity item) {
    Navigator.of(context)
        .pushNamed(
          AppRoutes.manualAddressEntry,
          arguments: item.toLocationEntity(),
        )
        .then((result) {
          if (!mounted || result is! LocationEntity) return;
          context.read<CustomerAddressesViewModel>().doIntent(
            CustomerAddressUpdateEvent(
              originalAddress: item,
              updatedLocation: result,
            ),
          );
        });
  }

  Future<void> _confirmDelete(CustomerAddressEntity item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteAddressDialog(item: item),
    );

    if (shouldDelete == true && mounted) {
      context.read<CustomerAddressesViewModel>().doIntent(
        CustomerAddressDeleteEvent(item.id),
      );
    }
  }

  String _resolveActionMessage(
    AppLocalizations l10n,
    CustomerAddressesState state,
  ) {
    switch (state.actionType) {
      case CustomerAddressesActionType.deleteSuccess:
        return l10n.addresses_delete_success;
      case CustomerAddressesActionType.setDefaultSuccess:
        return l10n.addresses_set_default_success(state.actionLabel ?? '');
      case CustomerAddressesActionType.editSuccess:
        return l10n.addresses_edit_success;
      case null:
        return '';
    }
  }
}

extension on CustomerAddressEntity {
  LocationEntity toLocationEntity() {
    return LocationEntity(
      addressLine: addressLine,
      city: city,
      area: area,
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      buildingNo: buildingNo ?? '',
      floorNo: floorNo ?? '',
      apartmentNo: apartmentNo ?? '',
      label: label,
    );
  }
}

class _AddressesErrorView extends StatelessWidget {
  const _AddressesErrorView({required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ApiErrorWidget(
          exception: failure.exception,
          onRetry: () =>
              context.read<CustomerAddressesViewModel>()
                ..doIntent(const CustomerAddressesRetryEvent()),
        ),
      ),
    );
  }
}
