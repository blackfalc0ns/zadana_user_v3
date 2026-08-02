import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay/pay.dart' show ApplePayButtonType, RawApplePayButton;
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/moyasar_payment_screen.dart';
import 'package:zadana_user_v3/feature/payment/presentation/services/moyasar_apple_pay_service.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_bottom_action.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const payChannel = MethodChannel('plugins.flutter.io/pay');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(payChannel, null);
  });

  test('Apple Pay selector uses a neutral wallet icon', () {
    expect(
      resolvePaymentMethodIcon('apple_pay'),
      Icons.account_balance_wallet_outlined,
    );
    expect(resolvePaymentMethodIcon('apple_pay'), isNot(Icons.apple));
  });

  testWidgets('checkout action uses Apple native checkout button', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    try {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ApplePayBottomAction(onPressed: _noop)),
        ),
      );

      final button = tester.widget<RawApplePayButton>(
        find.byType(RawApplePayButton),
      );
      expect(button.type, ApplePayButtonType.checkout);
      expect(button.key, const ValueKey('apple-pay-checkout-en'));
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.textContaining('Apple Pay'), findsNothing);

      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ApplePayBottomAction(onPressed: _noop)),
        ),
      );
      final arabicButton = tester.widget<RawApplePayButton>(
        find.byType(RawApplePayButton),
      );
      expect(arabicButton.key, const ValueKey('apple-pay-checkout-ar'));
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  test(
    'closing the native Apple Pay sheet is treated as cancellation',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(payChannel, (call) async {
            if (call.method == 'userCanPay') return true;
            if (call.method == 'showPaymentSelector') {
              throw PlatformException(code: 'paymentCanceled');
            }
            return null;
          });

      try {
        final result = await const MoyasarApplePayService().startPayment(
          config: _applePayConfig,
          orderId: 'order-1',
        );
        expect(result, isNull);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );

  test('reports when no eligible Apple Pay card is available', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(payChannel, (call) async {
          if (call.method == 'userCanPay') return false;
          return null;
        });

    try {
      expect(
        () => const MoyasarApplePayService().startPayment(
          config: _applePayConfig,
          orderId: 'order-1',
        ),
        throwsA(isA<ApplePayUnavailableException>()),
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
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
            home: MoyasarPaymentScreen(config: _applePayConfig),
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

const _applePayConfig = MoyasarProviderConfigEntity(
  publishableKey: 'pk_test',
  amount: 1000,
  currency: 'SAR',
  description: 'Test order',
  callbackUrl: 'https://example.com/payment/callback',
  methods: ['applepay'],
  supportedNetworks: ['visa'],
  metadata: {},
);

void _noop() {}
