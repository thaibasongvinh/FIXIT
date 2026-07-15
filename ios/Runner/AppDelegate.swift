import Flutter
import UIKit
import GoogleMaps
import FBSDKCoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Facebook SDK
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

    GMSServices.provideAPIKey("AIzaSyCqi1E0OXUYTxv6kjqcQ-tq64NCBYtP9Zo")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
      _ app: UIApplication,
      open url: URL,
      options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
      return ApplicationDelegate.shared.application(
          app,
          open: url,
          sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
          annotation: options[UIApplication.OpenURLOptionsKey.annotation]
      )
  }
}
