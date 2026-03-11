import 'package:flutter/material.dart';

class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: CircularProgressIndicator(
        color: colorScheme.primary,
      ),
    );
  }
}
