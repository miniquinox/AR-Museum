import 'dart:convert';
import 'package:http/http.dart' as http;

class Artwork {
  final String artName;
  final String frontImageUrl;
  final String lumaUrl;
  final String gradientColor;
  final String zipCode;
  final List<ArtworkDetail> artworks;

  Artwork({
    required this.artName,
    required this.frontImageUrl,
    required this.lumaUrl,
    required this.gradientColor,
    required this.zipCode,
    required this.artworks,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    var artworksList = json['artworks'] as List;
    List<ArtworkDetail> artworks =
        artworksList.map((i) => ArtworkDetail.fromJson(i)).toList();
    return Artwork(
      artName: json['artName'],
      frontImageUrl: json['frontImageUrl'],
      lumaUrl: json['lumaUrl'],
      gradientColor: json['gradientColor'],
      zipCode: json['zipCode'],
      artworks: artworks,
    );
  }
}

class ArtworkDetail {
  final String title;
  final String imageUrl;
  final String description;
  final String imageDetectionUrl;
  final String usdzUrl;

  ArtworkDetail({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.imageDetectionUrl,
    required this.usdzUrl,
  });

  factory ArtworkDetail.fromJson(Map<String, dynamic> json) {
    return ArtworkDetail(
      title: json['title'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      imageDetectionUrl: json['imageDetectionUrl'],
      usdzUrl: json['usdzUrl'],
    );
  }
}

Future<List<Artwork>> loadArtworks() async {
  const String url =
      'https://raw.githubusercontent.com/miniquinox/AR-Museum-Public-Files/main/newJson.json';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    List<Artwork> artworks = [];
    json.forEach((key, value) {
      artworks.add(Artwork.fromJson(value));
    });
    return artworks;
  } else {
    throw Exception('Failed to load artworks');
  }
}
