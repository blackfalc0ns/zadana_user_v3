import Flutter
import PassKit
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var applePayDiagnosticsChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    GeneratedPluginRegistrant.register(with: self)
    registerApplePayDiagnosticsChannel()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerApplePayDiagnosticsChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      NSLog("[ApplePayDiagnostics] FlutterViewController is unavailable")
      return
    }

    let channel = FlutterMethodChannel(
      name: "com.zadnauser/apple_pay_diagnostics",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "collect":
        guard
          let arguments = call.arguments as? [String: Any],
          let merchantIdentifier = arguments["merchantIdentifier"] as? String,
          let networkNames = arguments["supportedNetworks"] as? [String]
        else {
          result(
            FlutterError(
              code: "invalid_arguments",
              message: "Apple Pay diagnostics arguments are invalid",
              details: nil
            )
          )
          return
        }

        let diagnostics = self?.collectApplePayDiagnostics(
          merchantIdentifier: merchantIdentifier,
          networkNames: networkNames
        ) ?? [:]
        self?.logApplePayDiagnostics(diagnostics)
        result(diagnostics)
      case "log":
        guard
          let arguments = call.arguments as? [String: Any],
          let message = arguments["message"] as? String
        else {
          result(
            FlutterError(
              code: "invalid_arguments",
              message: "Apple Pay log arguments are invalid",
              details: nil
            )
          )
          return
        }

        let level = arguments["level"] as? Int ?? 0
        let errorType = arguments["errorType"] as? String
        if let errorType {
          NSLog(
            "[ApplePayDiagnostics] level=%d errorType=%@ %@",
            level,
            errorType,
            message
          )
        } else {
          NSLog("[ApplePayDiagnostics] level=%d %@", level, message)
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    applePayDiagnosticsChannel = channel
  }

  private func collectApplePayDiagnostics(
    merchantIdentifier: String,
    networkNames: [String]
  ) -> [String: Any] {
    let networks = networkNames.compactMap(paymentNetwork)
    let canMakePayments = PKPaymentAuthorizationController.canMakePayments()
    let canMakePaymentsUsingNetworks =
      !networks.isEmpty
      && PKPaymentAuthorizationController.canMakePayments(usingNetworks: networks)

    #if targetEnvironment(simulator)
      let isSimulator = true
    #else
      let isSimulator = false
    #endif

    return [
      "bundleIdentifier": Bundle.main.bundleIdentifier ?? "unknown",
      "deviceModel": UIDevice.current.model,
      "isIPad": UIDevice.current.userInterfaceIdiom == .pad,
      "isSimulator": isSimulator,
      "systemName": UIDevice.current.systemName,
      "systemVersion": UIDevice.current.systemVersion,
      "regionCode": Locale.current.regionCode ?? "unknown",
      "merchantIdentifier": merchantIdentifier,
      "requestedNetworks": networkNames,
      "recognizedNetworks": networks.map(\.rawValue),
      "canMakePayments": canMakePayments,
      "canMakePaymentsUsingNetworks": canMakePaymentsUsingNetworks,
    ]
  }

  private func paymentNetwork(from name: String) -> PKPaymentNetwork? {
    switch name.lowercased().replacingOccurrences(of: "_", with: "") {
    case "amex", "americanexpress":
      return .amex
    case "mada":
      return .mada
    case "mastercard":
      return .masterCard
    case "visa":
      return .visa
    default:
      return nil
    }
  }

  private func logApplePayDiagnostics(_ diagnostics: [String: Any]) {
    guard
      JSONSerialization.isValidJSONObject(diagnostics),
      let data = try? JSONSerialization.data(
        withJSONObject: diagnostics,
        options: [.sortedKeys]
      ),
      let message = String(data: data, encoding: .utf8)
    else {
      NSLog("[ApplePayDiagnostics] Could not serialize diagnostics")
      return
    }
    NSLog("[ApplePayDiagnostics] %@", message)
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }
}
