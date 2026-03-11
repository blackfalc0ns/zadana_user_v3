
import 'package:flutter/material.dart';

class ProfileMenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}