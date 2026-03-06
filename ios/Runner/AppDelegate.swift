import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var secureFields: [UIWindowScene: UITextField] = [:]

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
      name: "de.kiefer-networks.sshvault/screen_protection",
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
    for scene in UIApplication.shared.connectedScenes {
      guard let windowScene = scene as? UIWindowScene,
            secureFields[windowScene] == nil,
            let window = windowScene.windows.first else { continue }
      let field = UITextField()
      field.isSecureTextEntry = true
      field.translatesAutoresizingMaskIntoConstraints = false
      field.isUserInteractionEnabled = false
      window.addSubview(field)
      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
      secureFields[windowScene] = field
    }
  }

  private func disableScreenProtection() {
    for (scene, field) in secureFields {
      field.removeFromSuperview()
      secureFields.removeValue(forKey: scene)
    }
  }
}
