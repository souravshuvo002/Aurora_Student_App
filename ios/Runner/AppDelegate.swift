import UIKit
import Flutter
import FirebaseCore 

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
     if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self
     }
  
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}