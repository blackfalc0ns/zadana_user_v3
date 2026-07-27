import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/moyasar_payment_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const payChannel = MethodChannel('plugins.flutter.io/pay');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(payChannel, null);
  });

  testWidgets(
    'shows an unavailable message instead of an Apple Pay mark button',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(payChannel, (call) async {
            if (call.method == 'userCanPay') return false;
            return null;
          });

      try {
        await tester.pumpWidget(
          const MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MoyasarPaymentScreen(
              config: MoyasarProviderConfigEntity(
                publishableKey: 'pk_test',
                amount: 1000,
                currency: 'SAR',
                description: 'Test order',
                callbackUrl: 'https://example.com/payment/callback',
                methods: ['applepay'],
                supportedNetworks: ['visa'],
                metadata: {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Apple Pay is not available with an eligible card on this device. '
            'Add a supported card to Wallet or go back and choose another '
            'payment method.',
          ),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.apple), findsNothing);
        expect(
          find.byIcon(Icons.account_balance_wallet_outlined),
          findsOneWidget,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
