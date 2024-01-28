import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    var isModelPlaced = false
    var modelURL: URL? // Property to store the local URL of the downloaded model
    // let modelURLString = "https://raw.githubusercontent.com/miniquinox/AR-Museum-Public-Files/main/Mustang.usdz"
    let modelURLString = "https://raw.githubusercontent.com/miniquinox/AR-Museum-Public-Files/main/Ford_Mustang_Shelby_GT500.usdz"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        addLightingToScene()
        download3DModel(from: modelURLString)
    }

    func setupSceneView() {
        sceneView = ARSCNView(frame: view.frame)
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
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
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) ?? Set<ARReferenceImage>()
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
              imageAnchor.referenceImage.name == "laundry",
              !isModelPlaced,
              let modelURL = self.modelURL else {
            return
        }

        DispatchQueue.main.async {
            self.loadModel(from: modelURL, completion: { modelNode in
                guard let modelNode = modelNode else {
                    print("Failed to load 3D model")
                    return
                }
                node.addChildNode(modelNode)
                self.isModelPlaced = true
                print("3D model loaded and added to the scene")
            })
        }
    }

    func loadModel(from url: URL, completion: @escaping (SCNNode?) -> Void) {
        DispatchQueue.global().async {
            guard let scene = try? SCNScene(url: url, options: nil),
                  let modelNode = scene.rootNode.childNodes.first else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            modelNode.scale = SCNVector3(0.001, 0.001, 0.001)
            modelNode.position = SCNVector3(0, 0.1, 0)
            DispatchQueue.main.async {
                completion(modelNode)
            }
        }
    }
}
