import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_event.dart';
import 'package:zadana_user_v3/feature/location/presentation/manager/location_view_model.dart';

mixin AddressFormMixin<T extends StatefulWidget> on State<T> {
  final Map<String, String> labelOptions = {
    'المنزل': 'Home',
    'العمل': 'Work',
    'أخرى': 'Other',
  };
  
  String? selectedLabel;

  void initializeLabel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<LocationViewModel>().state;
      
      if (state.label.isEmpty) {
        selectedLabel = 'المنزل';
        context.read<LocationViewModel>().doIntent(
          UpdateLabelEvent('Home'),
        );
      } else {
        final labelEntry = labelOptions.entries.firstWhere(
          (entry) => entry.value == state.label,
          orElse: () => const MapEntry('المنزل', 'Home'),
        );
        selectedLabel = labelEntry.key;
      }
    });
  }

  void onLabelChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedLabel = newValue;
      });
      
      final stringValue = labelOptions[newValue]!;
      context.read<LocationViewModel>().doIntent(
        UpdateLabelEvent(stringValue),
      );
    }
  }

  void showLabelError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('يرجى اختيار تسمية العنوان'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  bool validateLabel() => selectedLabel != null;
}