import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    guard let windowScene = scene as? UIWindowScene else { return }

    // Enable full-screen on iPad by default
    if #available(iOS 16.0, *) {
      windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
    }
  }
}
