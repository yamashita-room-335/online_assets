import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController

    let api = OnDemandResourcesApiImplementation()
    OnDemandResourcesHostApiMethodsSetup.setUp(
      binaryMessenger: controller.binaryMessenger, api: api)

    let eventListener = OnDemandResourcesStreamHandler.shared
    OnDemandResourcesStreamHandler.register(
      with: controller.binaryMessenger, streamHandler: eventListener)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
