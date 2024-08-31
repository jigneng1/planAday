import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDm4ccjZLWgT4hMrRIFwvHw2twI0Uw0rBI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// AppDelegate.swift
// import UIKit
// import GoogleMaps

// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate {

//     var window: UIWindow?

//     func application(_ application: UIApplication,
//                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//         // Provide the API key
//         GMSServices.provideAPIKey("API_key")
//         return true
//     }
// }

