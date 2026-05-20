import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var screenshotOverlay: UIView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let securityChannel = FlutterMethodChannel(name: "com.example.login/security",
                                              binaryMessenger: controller.binaryMessenger)

    securityChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "setSecureMode" {
          // El FLAG_SECURE equivalente en iOS se maneja mejor ocultando la vista en el App Switcher
          result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // Prevención de filtración en el App Switcher (Multitarea)
  override func applicationWillResignActive(_ application: UIApplication) {
      if screenshotOverlay == nil {
          let blurEffect = UIBlurEffect(style: .extraLight)
          let blurWidget = UIVisualEffectView(effect: blurEffect)
          blurWidget.frame = window!.frame
          blurWidget.tag = 9988
          screenshotOverlay = blurWidget
      }
      window?.addSubview(screenshotOverlay!)
      super.applicationWillResignActive(application)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
      window?.viewWithTag(9988)?.removeFromSuperview()
      super.applicationDidBecomeActive(application)
  }
}
