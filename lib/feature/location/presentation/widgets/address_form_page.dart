import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_state.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';
import 'package:zadana_user_v3/feature/location/presentation/widgets/address_form_widgets.dart';

class AddressFormPage extends StatelessWidget {
  final String title;
  final Widget formContent;
  final bool isLoading;
  final VoidCallback onConfirm;
  final String confirmButtonText;

  const AddressFormPage({
    super.key,
    required this.title,
    required this.formContent,
    required this.isLoading,
    required this.onConfirm,
    required this.confirmButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: BlocConsumer<LocationViewModel, LocationState>(
        listener: (context, state) {
          if (state.errorMessage?.isNotEmpty == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) => SafeArea(
          child: Column(
            children: [
              Expanded(child: formContent),
              AddressFormWidgets.buildConfirmButton(
                isLoading: state.isLoading,
                onPressed: onConfirm,
                text: confirmButtonText,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}