import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';

abstract class ToastMessage {
  static Future<bool?> toastMsg(
    String msg, {
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor ?? AppColors.backgroundDark,
      textColor: textColor ?? AppColors.white,
      fontSize: 16,
    );
  }
}
