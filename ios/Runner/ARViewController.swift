import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    var isModelPlaced = false // Flag to check if the model is already placed

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        sceneView.delegate = self
        sceneView.showsStatistics = true

        let scene = SCNScene()
        sceneView.scene = scene

        addLightingToScene(scene: scene)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("View will appear")

        let configuration = ARWorldTrackingConfiguration()

        if ARWorldTrackingConfiguration.isSupported {
            guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
                fatalError("Images not found")
            }
            configuration.detectionImages = referenceImages
            // Enable people occlusion if it's supported
            if #available(iOS 13.0, *), ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
                configuration.frameSemantics.insert(.personSegmentationWithDepth)
            }
            print("People occlusion is enabled")
        } else {
            print("ARWorldTrackingConfiguration is not supported on this device")
            return
        }

        sceneView.session.run(configuration)
        print("World Tracking Session started with configuration: \(configuration)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
        print("Session paused")
    }


    func addLightingToScene(scene: SCNScene) {
        // Add ambient light
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 1000 // Ambient light intensity
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

        // Add directional light
        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.intensity = 1000 // Directional light intensity
        directionalLight.castsShadow = true // Enable shadows
        let directionalLightNode = SCNNode()
        directionalLightNode.light = directionalLight
        directionalLightNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0) // Adjust the angle to suit your scene
        scene.rootNode.addChildNode(directionalLightNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Renderer did add node for anchor")
        
        guard let imageAnchor = anchor as? ARImageAnchor else {
            print("The anchor is not an ARImageAnchor")
            return
        }

        print("Detected image named: \(imageAnchor.referenceImage.name ?? "")")

        if imageAnchor.referenceImage.name == "laundry" {
            print("Correct image detected")
            DispatchQueue.main.async {
                if let modelNode = self.load3DModel() {
                    node.addChildNode(modelNode)
                    print("3D model loaded and added to the scene")
                } else {
                    print("Failed to load 3D model")
                }
            }
        }
    }

    func load3DModel() -> SCNNode? {
        // guard let scene = SCNScene(named: "Starry_Night.usdz") else {
        guard let scene = SCNScene(named: "Mustang.usdz") else {
            print("Error: Could not find 3D model file.")
            return nil
        }

        guard let modelNode = scene.rootNode.childNodes.first else {
            print("Error: Could not retrieve the model node.")
            return nil
        }

        print("3D model file found and loaded")
        modelNode.scale = SCNVector3(0.001, 0.001, 0.001) // Adjust the scale
        modelNode.position = SCNVector3(0, 0.1, 0) // Adjust the position

        return modelNode
    }
}
