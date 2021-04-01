import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
     // TODO: Add your API key
    GMSServices.provideAPIKey("AIzaSyCXX1jSkEVMzI9GbJRAHoTxh8uCET33vl8")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
