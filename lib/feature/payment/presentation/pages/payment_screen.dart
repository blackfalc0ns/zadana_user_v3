import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_event.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_view_model.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_screen_content.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, this.vendorId});

  final String? vendorId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PaymentViewModel>()
            ..initialize(vendorId: vendorId)
            ..doIntent(const PaymentLoadEvent()),
      child: const PaymentScreenContent(),
    );
  }
}
