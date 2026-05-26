import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/get_notification_preferences_usecase.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/update_notification_preferences_usecase.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  bool _pushEnabled = true;
  String _sound = 'default';

  static const _soundOptions = ['default', 'silent', 'chime', 'alert'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final result = await getIt<GetNotificationPreferencesUseCase>()();
    if (!mounted) return;

    switch (result) {
      case ApiSuccessResult<Map<String, dynamic>>():
        setState(() {
          _isLoading = false;
          _pushEnabled = result.data['push_enabled'] as bool? ?? true;
          _sound = result.data['sound']?.toString() ?? 'default';
        });
      case ApiErrorResult<Map<String, dynamic>>():
        setState(() => _isLoading = false);
        if (mounted) {
          CustomSnackbar.showError(
            context: context,
            message: result.failure.errorMessage,
          );
        }
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);

    final result = await getIt<UpdateNotificationPreferencesUseCase>()({
      'push_enabled': _pushEnabled,
      'sound': _sound,
    });

    if (!mounted) return;
    setState(() => _isSaving = false);

    switch (result) {
      case ApiSuccessResult<void>():
        CustomSnackbar.showSuccess(
          context: context,
          message: _isArabic ? 'تم حفظ الإعدادات' : 'Preferences saved',
        );
      case ApiErrorResult<void>():
        CustomSnackbar.showError(
          context: context,
          message: result.failure.errorMessage,
        );
    }
  }

  bool get _isArabic =>
      Localizations.localeOf(context).languageCode.startsWith('ar');

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isArabic = _isArabic;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: CustomAppBar(
        title: isArabic ? 'إعدادات الإشعارات' : 'Notification Settings',
        showShadow: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(Spacing.base),
              children: [
                _SectionCard(
                  children: [
                    SwitchListTile.adaptive(
                      title: Text(
                        isArabic ? 'الإشعارات' : 'Push Notifications',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          color: colors.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        isArabic
                            ? 'استقبال إشعارات على الجهاز'
                            : 'Receive push notifications on this device',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      value: _pushEnabled,
                      onChanged: (value) {
                        setState(() => _pushEnabled = value);
                        _savePreferences();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.base),
                _SectionCard(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text(
                        isArabic ? 'صوت الإشعار' : 'Notification Sound',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    ..._soundOptions.map((option) {
                      return RadioListTile<String>(
                        title: Text(
                          _soundLabel(option, isArabic),
                          style: TextStyle(
                            fontFamily: FontConstant.cairo,
                            color: colors.onSurface,
                          ),
                        ),
                        value: option,
                        groupValue: _sound,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _sound = value);
                          _savePreferences();
                        },
                      );
                    }),
                  ],
                ),
                if (_isSaving) ...[
                  const SizedBox(height: Spacing.lg),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
    );
  }

  String _soundLabel(String sound, bool isArabic) {
    switch (sound) {
      case 'default':
        return isArabic ? 'الافتراضي' : 'Default';
      case 'silent':
        return isArabic ? 'صامت' : 'Silent';
      case 'chime':
        return isArabic ? 'رنين' : 'Chime';
      case 'alert':
        return isArabic ? 'تنبيه' : 'Alert';
      default:
        return sound;
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
