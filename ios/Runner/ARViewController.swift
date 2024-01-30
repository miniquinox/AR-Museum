import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    var isModelPlaced = false
    var modelURL: URL?
    var modelURLString: String?
    var imageName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        addLightingToScene()
        if let modelURLString = self.modelURLString {
            prepareModel(from: modelURLString)
        }
        addCloseButton()
    }

    func setupSceneView() {
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        // Enable automatic lighting to improve the appearance of the model
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
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil),
           let imageName = imageName, let imageToTrack = trackedImages.first(where: { $0.name == imageName }) {
            configuration.detectionImages = [imageToTrack]
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Enable people occlusion if supported
        if #available(iOS 13.0, *), ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }

        sceneView.session.run(configuration)
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

    func prepareModel(from urlString: String) {
        // Fixed to ensure urlString is used directly
        guard let url = URL(string: urlString) else {
            print("Invalid URL for the 3D model")
            return
        }

        // Simplifying file path construction and checking
        let fileManager = FileManager.default
        do {
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let permanentUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
            
            if fileManager.fileExists(atPath: permanentUrl.path) {
                print("Model already downloaded.")
                self.modelURL = permanentUrl
            } else {
                print("Model needs to be downloaded.")
                download3DModel(from: urlString) // Correctly passing urlString
            }
        } catch {
            print("Error obtaining document directory: \(error)")
        }
    }

    func download3DModel(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL for the 3D model")
            return
        }

        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] (tempLocalUrl, response, error) in
            guard let tempLocalUrl = tempLocalUrl, error == nil else {
                print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let fileManager = FileManager.default
            do {
                let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let permanentUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                if fileManager.fileExists(atPath: permanentUrl.path) {
                    try fileManager.removeItem(at: permanentUrl)
                }
                try fileManager.moveItem(at: tempLocalUrl, to: permanentUrl)
                print("Downloaded model to: \(permanentUrl)")
                DispatchQueue.main.async {
                    self?.modelURL = permanentUrl
                }
            } catch {
                print("Could not save file to document directory: \(error)")
            }
        }
        downloadTask.resume()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor,
            imageAnchor.referenceImage.name == imageName else { return }

        // Check if the model has already been placed to avoid adding it more than once.
        if !isModelPlaced, let modelURL = self.modelURL {
            DispatchQueue.main.async {
                if let modelNode = self.loadModel(from: modelURL) {
                    // Attach the model to the root node instead of the image anchor's node.
                    // This way, the model will not be affected by the visibility of the image anchor.
                    self.sceneView.scene.rootNode.addChildNode(modelNode)
                    
                    // Adjust the model's position based on the image anchor's real-world position.
                    // This initial placement aligns the model with the image, but it won't move or disappear with the image.
                    modelNode.position = SCNVector3(node.worldPosition.x, node.worldPosition.y, node.worldPosition.z)
                    
                    self.isModelPlaced = true
                    print("3D model loaded and added to the scene")
                }
            }
        }
    }


    func loadModel(from url: URL) -> SCNNode? {
        guard let scene = try? SCNScene(url: url, options: nil),
              let modelNode = scene.rootNode.childNodes.first else {
            print("Failed to load 3D model from \(url)")
            return nil
        }
        
        // Configure the model node as needed
        modelNode.scale = SCNVector3(0.001, 0.001, 0.001) // Adjust based on your model's size
        modelNode.position = SCNVector3(0, 0, -0.5) // Adjust based on your needs
        
        return modelNode
    }

    func addCloseButton() {
    let closeButton = UIButton(type: .system)
    closeButton.frame = CGRect(x: 20, y: 40, width: 30, height: 30) // Adjust size and position as needed
    if let closeImage = UIImage(systemName: "xmark") { // Using a system image
        closeButton.setImage(closeImage, for: .normal)
    }
    closeButton.tintColor = .white // Change color as needed
    closeButton.addTarget(self, action: #selector(dismissARView), for: .touchUpInside)
    self.view.addSubview(closeButton)
}

    @objc func dismissARView() {
        self.dismiss(animated: true, completion: nil)
    }
}