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
      
      arKitChannel.setMethodCallHandler { [weak self] (call, result) in
        guard let self = self else { return }
        
        if call.method == "openARView",
           let args = call.arguments as? [String: String],
           let modelURLString = args["modelURLString"],
           let imageName = args["imageName"] {
          self.openARView(from: controller, modelURLString: modelURLString, imageName: imageName)
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  private func openARView(from controller: FlutterViewController, modelURLString: String, imageName: String) {
    // Ensure ARViewController can handle modelURLString and imageName
    let arViewController = ARViewController()
    arViewController.modalPresentationStyle = .fullScreen // Ensure full screen mode
    // Pass parameters to ARViewController
    arViewController.modelURLString = modelURLString
    arViewController.imageName = imageName
    controller.present(arViewController, animated: true, completion: nil)
  }
}