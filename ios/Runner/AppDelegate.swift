import UIKit
import Flutter
import ARKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        if let controller = window?.rootViewController as? FlutterViewController {
            let methodChannel = FlutterMethodChannel(name: "com.example.davisProject/", binaryMessenger: controller.binaryMessenger)
            
            methodChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if call.method == "openARView", let args = call.arguments as? [String: String], let modelPath = args["modelPath"], let imagePath = args["imagePath"] {
                    self?.openARView(modelPath: modelPath, imagePath: imagePath, result: result)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            })
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func openARView(modelPath: String, imagePath: String, result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                result(FlutterError(code: "SELF_UNAVAILABLE", message: "Reference to self is unavailable", details: nil))
                return
            }
            
            if let viewController = self.window?.rootViewController {
                let arViewController = ARViewController()
                arViewController.modelPath = modelPath
                arViewController.imagePath = imagePath
                viewController.present(arViewController, animated: true, completion: nil)
                result("AR View opened")
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Unable to open AR view", details: nil))
            }
        }
    }
}


class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    var modelPath: String?
    var imagePath: String?
    var isModelPlaced = false // Track if the model has already been placed to avoid re-placing it

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        addLightingToScene()
        addCloseButton()
    }

    func setupSceneView() {
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupARSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func setupARSession() {
        guard ARWorldTrackingConfiguration.isSupported else {
            print("ARWorldTrackingConfiguration is not supported on this device")
            return
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        if let imagePath = self.imagePath, let imageToTrack = loadImageForTracking(imagePath: imagePath) {
            configuration.detectionImages = [imageToTrack]
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        if #available(iOS 13.0, *), ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }

        sceneView.session.run(configuration)
    }

    func loadImageForTracking(imagePath: String) -> ARReferenceImage? {
        guard let image = UIImage(contentsOfFile: imagePath), let cgImage = image.cgImage else {
            print("Failed to load image from provided path")
            return nil
        }
        
        let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.2) // Adjust physicalWidth as needed
        referenceImage.name = "DynamicImage"
        return referenceImage
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor, !isModelPlaced else { return }

        if let modelPath = self.modelPath, let modelURL = URL(string: modelPath), let modelNode = loadModel(from: modelURL) {
            DispatchQueue.main.async {
                self.sceneView.scene.rootNode.addChildNode(modelNode)
                modelNode.position = SCNVector3(node.worldPosition.x, node.worldPosition.y, node.worldPosition.z)
                self.isModelPlaced = true
                print("3D model loaded and added to the scene")
            }
        }
    }

    func loadModel(from url: URL) -> SCNNode? {
        do {
            let scene = try SCNScene(url: url, options: nil)
            let modelNode = scene.rootNode.childNodes.first
            modelNode?.scale = SCNVector3(0.001, 0.001, 0.001) // Adjust as needed
            modelNode?.position = SCNVector3(0, 0, -0.5) // Adjust as needed
            return modelNode
        } catch {
            print("Failed to load 3D model from \(url): \(error)")
            return nil
        }
    }

    func addLightingToScene() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.intensity = 1000
        sceneView.scene.rootNode.addChildNode(ambientLightNode)

        let directionalLightNode = SCNNode()
        directionalLightNode.light = SCNLight()
        directionalLightNode.light?.type = .directional
        directionalLightNode.light?.intensity = 1000
        directionalLightNode.light?.castsShadow = true
        directionalLightNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
        sceneView.scene.rootNode.addChildNode(directionalLightNode)
    }

    func addCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: 20, y: 40, width: 30, height: 30)
        if let closeImage = UIImage(systemName: "xmark") {
            closeButton.setImage(closeImage, for: .normal)
        }
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(dismissARView), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }

    @objc func dismissARView() {
        self.dismiss(animated: true, completion: nil)
    }
}