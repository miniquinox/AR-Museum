import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    if let controller = window?.rootViewController as? FlutterViewController {
      let arKitChannel = FlutterMethodChannel(name: "com.example.davisProject",
                                              binaryMessenger: controller.binaryMessenger)
      
      arKitChannel.setMethodCallHandler { [unowned self] (call, result) in
        if call.method == "openARView" {
          self.openARView(from: controller)
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func openARView(from controller: FlutterViewController) {
    let arViewController = ARViewController()
    controller.present(arViewController, animated: true, completion: nil)
  }
}
