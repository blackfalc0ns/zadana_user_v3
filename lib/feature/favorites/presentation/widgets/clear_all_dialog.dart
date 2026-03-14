import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';

class ClearAllDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ClearAllDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('مسح جميع المفضلة'),
      content: const Text('هل أنت متأكد من أنك تريد إزالة جميع المنتجات من المفضلة؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text(
            'مسح الكل',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
