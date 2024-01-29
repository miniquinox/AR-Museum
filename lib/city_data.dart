import 'dart:convert';
import 'package:flutter/services.dart';

// City class
class City {
  final String name;
  final String imagePath;
  final String jsonFile;
  final String webViewUrl;
  final Color gradientColor;
  final String inputImage;
  final String usdzFile;

  City({
    required this.name,
    required this.imagePath,
    required this.jsonFile,
    required this.webViewUrl,
    required this.gradientColor,
    required this.inputImage,
    required this.usdzFile,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      imagePath: json['imagePath'],
      jsonFile: json['jsonFile'],
      webViewUrl: json['webViewUrl'],
      gradientColor: _hexToColor(json['gradientColor']),
      inputImage: json['inputImage'], // New field
      usdzFile: json['usdzFile'], // New field
    );
  }

  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

// Function to load city data from JSON file
Future<List<City>> loadCities() async {
  final String response = await rootBundle.loadString('assets/cities.json');
  final List<dynamic> data = json.decode(response);
  return data.map<City>((json) => City.fromJson(json)).toList();
}
