import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ImageDetectionPage extends StatefulWidget {
  const ImageDetectionPage({super.key});

  @override
  _ImageDetectionPageState createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Find the landmark!')),
        body: ARKitSceneView(
          detectionImagesGroupName:
              'AR Resources', // This should match the AR Resources group name in Xcode.
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor) {
      final position = vector.Vector3(
        anchor.transform.getColumn(3).x,
        anchor.transform.getColumn(3).y,
        anchor.transform.getColumn(3).z,
      );

      final node = _createNodeForAnchor(position);
      arkitController.add(node);
    }
  }

  ARKitNode _createNodeForAnchor(vector.Vector3 position) {
    // Here you can choose to load either a .glb or .gltf file
    // For this example, we are loading a .glb file
    return ARKitGltfNode(
      assetType: AssetType.flutterAsset,
      // url: 'assets/fountain.glb', // Replace with your actual .glb asset path
      url: 'assets/Porsche2.glb', // Replace with your actual .glb asset path
      scale: vector.Vector3.all(0.1), // Adjust the scale if necessary
      position: position,
    );
  }
}
