import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class EditIconWidget extends StatelessWidget {
  const EditIconWidget({super.key, });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color.primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.surface,
          width: 1.5,
        ),
      ),
      child: const FaIcon(
        FontAwesomeIcons.pen,
        size: 8,
        color: Colors.white,
      ),
    );
  }
}
