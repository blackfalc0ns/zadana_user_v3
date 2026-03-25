import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class TitleWidget extends StatelessWidget {
  final double fontSize;

  const TitleWidget({
    super.key,
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    
    return Text(
      AppLocalizations.of(context)!.start_page_title,
      textAlign: TextAlign.center,
      maxLines: 3,
      style: getBoldStyle(
        fontFamily: FontConstant.cairo,
        color: color.surface,
        fontSize: fontSize,
      ),
    );
  }
}
