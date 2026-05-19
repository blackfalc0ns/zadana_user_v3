import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';

/// Screen shown after a bank transfer order is created.
/// The order is NOT paid yet — the user must transfer funds manually.
class BankTransferPendingScreen extends StatelessWidget {
  const BankTransferPendingScreen({
    super.key,
    required this.orderId,
    this.bankTransferConfig,
    this.providerReference,
  });

  final String orderId;
  final BankTransferConfigEntity? bankTransferConfig;
  final String? providerReference;

  void _navigateBackToHome(BuildContext context) {
    var foundMainShell = false;
    Navigator.of(context).popUntil((route) {
      final isMainShell = route.settings.name == AppRoutes.mainShell ||
          route.settings.name == AppRoutes.home;
      if (isMainShell) foundMainShell = true;
      return isMainShell || route.isFirst;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      if (foundMainShell && mainShellKey.currentState != null) {
        mainShellKey.currentState?.jumpToTab(0);
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    });
  }

  void _navigateToOrders(BuildContext context) {
    var foundMainShell = false;
    Navigator.of(context).popUntil((route) {
      final isMainShell = route.settings.name == AppRoutes.mainShell ||
          route.settings.name == AppRoutes.home;
      if (isMainShell) foundMainShell = true;
      return isMainShell || route.isFirst;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      if (foundMainShell && mainShellKey.currentState != null) {
        // Navigate to orders tab (index 2 typically, adjust if needed)
        Navigator.of(context).pushNamed(AppRoutes.myOrdersPage);
        return;
      }
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    });
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    CustomSnackbar.showSuccess(
      context: context,
      message: '$label copied',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final config = bankTransferConfig;
    final languageCode = Localizations.localeOf(context).languageCode;

    final title = languageCode == 'ar'
        ? 'تم إنشاء طلبك بنجاح'
        : 'Order Created Successfully';
    final subtitle = languageCode == 'ar'
        ? 'بانتظار التحويل البنكي'
        : 'Awaiting Bank Transfer';
    final description = languageCode == 'ar'
        ? 'يرجى تحويل المبلغ المطلوب إلى الحساب البنكي أدناه لإتمام الطلب.'
        : 'Please transfer the required amount to the bank account below to complete your order.';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _navigateBackToHome(context);
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // Status icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    size: 44,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: getBoldStyle(
                    fontSize: FontSize.size22,
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                    color: Colors.orange.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: getRegularStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Bank details card
                if (config != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          languageCode == 'ar'
                              ? 'تفاصيل الحساب البنكي'
                              : 'Bank Account Details',
                          style: getSemiBoldStyle(
                            fontSize: FontSize.size16,
                            fontFamily: FontConstant.cairo,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          context,
                          label: languageCode == 'ar' ? 'البنك' : 'Bank',
                          value: config.bankName,
                        ),
                        _buildDetailRow(
                          context,
                          label: languageCode == 'ar'
                              ? 'اسم صاحب الحساب'
                              : 'Account Holder',
                          value: config.accountHolderName,
                        ),
                        _buildCopyableRow(
                          context,
                          label: languageCode == 'ar' ? 'آيبان' : 'IBAN',
                          value: config.iban,
                        ),
                        _buildCopyableRow(
                          context,
                          label: languageCode == 'ar'
                              ? 'رقم الحساب'
                              : 'Account Number',
                          value: config.accountNumber,
                        ),
                        const Divider(height: 24),
                        _buildCopyableRow(
                          context,
                          label: languageCode == 'ar'
                              ? 'مرجع التحويل'
                              : 'Transfer Reference',
                          value: config.reference,
                          highlight: true,
                        ),
                        _buildDetailRow(
                          context,
                          label: languageCode == 'ar' ? 'المبلغ' : 'Amount',
                          value:
                              '${config.amount.toStringAsFixed(2)} ${config.currency}',
                          highlight: true,
                        ),
                        if (config.expiresAtUtc != null &&
                            config.expiresAtUtc!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            context,
                            label: languageCode == 'ar'
                                ? 'ينتهي في'
                                : 'Expires At',
                            value: _formatExpiry(config.expiresAtUtc!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ] else if (providerReference != null &&
                    providerReference!.isNotEmpty) ...[
                  // Fallback: show at least the reference
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: _buildCopyableRow(
                      context,
                      label: languageCode == 'ar'
                          ? 'مرجع التحويل'
                          : 'Transfer Reference',
                      value: providerReference!,
                      highlight: true,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Info note
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          languageCode == 'ar'
                              ? 'سيتم تأكيد طلبك تلقائياً بعد استلام التحويل. يمكنك متابعة حالة الطلب من صفحة طلباتي.'
                              : 'Your order will be confirmed automatically once the transfer is received. You can track the order status from My Orders.',
                          style: getRegularStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Action buttons
                AppButton(
                  text: l10n.track_order,
                  icon: Icons.receipt_long_rounded,
                  onPressed: () => _navigateToOrders(context),
                  color: colors.primary,
                  textColor: colors.onPrimary,
                  height: Spacing.buttonHeight,
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.base,
                  ),
                ),
                const SizedBox(height: 12),
                AppButton.outlined(
                  text: l10n.back_to_home,
                  icon: Icons.home_rounded,
                  onPressed: () => _navigateBackToHome(context),
                  color: colors.primary,
                  textColor: colors.primary,
                  height: Spacing.buttonHeight,
                  borderRadius: 18,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.base,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    bool highlight = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: getRegularStyle(
                fontSize: FontSize.size13,
                fontFamily: FontConstant.cairo,
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: highlight
                  ? getSemiBoldStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: colors.primary,
                    )
                  : getMediumStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurface,
                    ),
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableRow(
    BuildContext context, {
    required String label,
    required String value,
    bool highlight = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: getRegularStyle(
                fontSize: FontSize.size13,
                fontFamily: FontConstant.cairo,
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: highlight
                  ? getSemiBoldStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: colors.primary,
                    )
                  : getMediumStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurface,
                    ),
              textDirection: TextDirection.ltr,
            ),
          ),
          InkWell(
            onTap: () => _copyToClipboard(context, value, label),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.copy_rounded,
                size: 18,
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatExpiry(String expiresAtUtc) {
    final dateTime = DateTime.tryParse(expiresAtUtc);
    if (dateTime == null) return expiresAtUtc;
    final local = dateTime.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
