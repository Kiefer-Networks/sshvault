import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var secureField: UITextField?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ScreenProtectionPlugin")
    let channel = FlutterMethodChannel(
      name: "de.kiefer-networks.shellvault/screen_protection",
      binaryMessenger: registrar!.messenger())
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      switch call.method {
      case "setFlagSecure":
        let args = call.arguments as? [String: Any]
        let enable = args?["enable"] as? Bool ?? false
        DispatchQueue.main.async {
          if enable {
            self.enableScreenProtection()
          } else {
            self.disableScreenProtection()
          }
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func enableScreenProtection() {
    guard secureField == nil else { return }
    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = scene.windows.first else { return }
    let field = UITextField()
    field.isSecureTextEntry = true
    window.addSubview(field)
    field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
    field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
    window.layer.superlayer?.addSublayer(field.layer)
    field.layer.sublayers?.last?.addSublayer(window.layer)
    secureField = field
  }

  private func disableScreenProtection() {
    secureField?.removeFromSuperview()
    secureField = nil
  }
}
