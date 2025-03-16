import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register EventListener
    let eventListener = OnDemandResourcePigeonStreamHandler()
    OnDemandResourcePigeonStreamHandler.register(
        with: window?.rootViewController as! FlutterBinaryMessenger, streamHandler: eventListener)

   // Setup HostAPI
      OnDemandResourcesHostApiMethodsSetup.setUp(
        binaryMessenger: window?.rootViewController as! FlutterBinaryMessenger,
        api: OnDemandResourcesPigeon.shared
    )

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
