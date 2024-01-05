import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'city_data.dart'; // Import your city data
import 'package:collection/collection.dart'; // Import collection package

class ImageDetectionPage extends StatefulWidget {
  const ImageDetectionPage({super.key});

  @override
  _ImageDetectionPageState createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  late ARKitController arkitController;
  late Future<List<City>> cities; // Future to hold city data

  @override
  void initState() {
    super.initState();
    cities = loadCities(); // Load cities data
  }

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Find the landmark!')),
        body: ARKitSceneView(
          detectionImagesGroupName: 'AR Resources',
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor) {
      // Debugging: print the name of the recognized image
      print("Image recognized: ${anchor.referenceImageName}");

      final position = vector.Vector3(
        anchor.transform.getColumn(3).x,
        anchor.transform.getColumn(3).y,
        anchor.transform.getColumn(3).z,
      );

      // Find the city corresponding to the detected image
      cities.then((loadedCities) {
        final city = loadedCities.firstWhereOrNull(
          (c) => c.inputImage == anchor.referenceImageName,
        );

        // Debugging: print details about the found city or if none was found
        if (city != null) {
          print("City found: ${city.name}, GLB File: ${city.glbFile}");
          final node = _createNodeForAnchor(city, position);
          arkitController.add(node);
        } else {
          print(
              "No matching city found for image: ${anchor.referenceImageName}");
        }
      });
    } else {
      print("Anchor detected is not an ARKitImageAnchor");
    }
  }

  ARKitNode _createNodeForAnchor(City city, vector.Vector3 position) {
    return ARKitGltfNode(
      assetType: AssetType.flutterAsset,
      url: city.glbFile,
      scale: vector.Vector3.all(0.1),
      position: position,
    );
  }
}
