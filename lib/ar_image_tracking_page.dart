import 'dart:async';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ImageDetectionPage extends StatefulWidget {
  @override
  _ImageDetectionPageState createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  late ARKitController arkitController;
  Timer? timer;
  ARKitNode? earthNode;

  @override
  void dispose() {
    timer?.cancel();
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Image Detection Sample')),
        body: ARKitSceneView(
          detectionImagesGroupName: 'AR Resources',
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = onAnchorWasFound;
    arkitController.onUpdateNodeForAnchor = onAnchorWasUpdated;
  }

  void onAnchorWasFound(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor && earthNode == null) {
      final material = ARKitMaterial(
        lightingModelName: ARKitLightingModel.lambert,
        diffuse: ARKitMaterialProperty.image('earth.jpg'),
      );
      final sphere = ARKitSphere(
        materials: [material],
        radius: 0.1,
      );

      final position = vector.Vector3(
        anchor.transform.getColumn(3).x,
        anchor.transform.getColumn(3).y,
        anchor.transform.getColumn(3).z,
      );

      earthNode = ARKitNode(
        geometry: sphere,
        position: position,
      );
      arkitController.add(earthNode!);
    }
  }

  void onAnchorWasUpdated(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor && earthNode != null) {
      final position = vector.Vector3(
        anchor.transform.getColumn(3).x,
        anchor.transform.getColumn(3).y,
        anchor.transform.getColumn(3).z,
      );

      earthNode!.position = position;
    }
  }
}
