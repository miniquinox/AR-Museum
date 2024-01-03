// city_data.dart
import 'package:flutter/material.dart';

class City {
  final String name;
  final String imagePath;
  final String jsonFile;
  final String webViewUrl;
  final Color gradientColor;

  City({
    required this.name,
    required this.imagePath,
    required this.jsonFile,
    required this.webViewUrl,
    required this.gradientColor,
  });
}

final List<City> cities = [
  City(
    name: 'San Francisco',
    imagePath: 'images/golden_gate.jpeg',
    jsonFile: 'assets/SF.json',
    webViewUrl:
        'https://lumalabs.ai/embed/e1316b43-d3bf-46c0-8d4d-db357176929d?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false', // Replace with actual URL
    gradientColor: Colors.blue.withOpacity(0.7),
  ),
  // Add more cities here
  City(
    name: 'Sevilla',
    imagePath: 'images/sevilla.jpeg',
    jsonFile: 'assets/Sevilla.json',
    webViewUrl:
        'https://lumalabs.ai/embed/e1316b43-d3bf-46c0-8d4d-db357176929d?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false', // Replace with actual URL
    gradientColor: Colors.orange.withOpacity(0.7),
  ),
  City(
    name: 'New York',
    imagePath: 'images/central_park.jpeg',
    jsonFile: 'assets/NYC.json',
    webViewUrl:
        'https://lumalabs.ai/embed/e1316b43-d3bf-46c0-8d4d-db357176929d?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false', // Replace with actual URL
    gradientColor: Colors.green.withOpacity(0.7),
  ),
  // Continue adding cities as needed
];
