import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/emotion_slider_widget.dart';

class DeliveryRatingDialog extends StatefulWidget {
  const DeliveryRatingDialog({
    super.key,
    required this.courierName,
    required this.courierImage,
    required this.onSubmit,
  });

  final String courierName;
  final String courierImage;
  final Function(int rating, String comment) onSubmit;

  @override
  State<DeliveryRatingDialog> createState() => _DeliveryRatingDialogState();
}

class _DeliveryRatingDialogState extends State<DeliveryRatingDialog> {
  final TextEditingController _commentController = TextEditingController();
  final int _starRating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - Courier Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: color.primary.withValues(alpha: 0.1),
                    backgroundImage: widget.courierImage.isNotEmpty
                        ? NetworkImage(widget.courierImage)
                        : null,
                    child: widget.courierImage.isEmpty
                        ? Icon(Icons.person, size: 28, color: color.primary)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.courierName,
                          style: getBoldStyle(
                            fontSize: 20,
                            fontFamily: FontConstant.cairo,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          locale.delivery_rating_delivered_to,
                          style: getRegularStyle(
                            fontSize: 14,
                            fontFamily: FontConstant.cairo,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Emotion Slider Widget (CustomPainter ile)
              Center(
                child: EmotionSliderWidget(
                  onEmotionChanged: (emotionIndex, label) {
                    // Emotion değeri kullanılabilir (şu an sadece star rating kullanılıyor)
                  },
                ),
              ),
              const SizedBox(height: 28),

              // Text Area
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.delivery_rating_write_comment,
                    style: getMediumStyle(
                      fontSize: 14,
                      fontFamily: FontConstant.cairo,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    maxLength: 200,
                    decoration: InputDecoration(
                      hintText: locale.delivery_rating_comment_hint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: color.primary, width: 1),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.all(12),
                      counterStyle: getRegularStyle(
                        fontSize: 12,
                        fontFamily: FontConstant.cairo,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    style: getRegularStyle(
                      fontSize: 14,
                      fontFamily: FontConstant.cairo,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: locale.delivery_rating_cancel,
                      onPressed: () => Navigator.of(context).pop(),
                      variant: AppButtonVariant.outlined,
                      height: 48,
                      borderRadius: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.transparent,
                      textColor: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: locale.delivery_rating_submit,
                      onPressed: () {
                        widget.onSubmit(_starRating, _commentController.text);
                        Navigator.of(context).pop();
                      },
                      height: 48,
                      borderRadius: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper method to show the delivery rating dialog
void showDeliveryRatingDialog(
  BuildContext context, {
  required String courierName,
  required String courierImage,
  required Function(int rating, String comment) onSubmit,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => DeliveryRatingDialog(
      courierName: courierName,
      courierImage: courierImage,
      onSubmit: onSubmit,
    ),
  );
}
