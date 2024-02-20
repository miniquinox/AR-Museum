import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'dataManager.dart'; // Ensure this file contains your Artwork class definition
import 'particles.dart'; // Assuming this is a custom widget you've defined.
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ArtworkDetailScreen extends StatefulWidget {
  final Artwork artwork;

  const ArtworkDetailScreen({Key? key, required this.artwork})
      : super(key: key);

  @override
  State<ArtworkDetailScreen> createState() => _ArtworkDetailScreenState();
}

class CityArtworkCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Color gradientColor;
  final String usdzUrl;
  final String imageDetectionUrl;
  final VoidCallback onTap;

  const CityArtworkCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.gradientColor,
    required this.usdzUrl,
    required this.imageDetectionUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradientColors = [Colors.transparent, gradientColor.withOpacity(0.7)];
    final gradientStops = [0.5, 1.0];

    return InkWell(
      onTap: onTap,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: gradientColors,
              stops: gradientStops,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
                const SizedBox(height: 8),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(imagePath,
                        fit: BoxFit.cover, height: 200)),
                const SizedBox(height: 8),
                Text(description,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  late WebViewController _webController;
  static const platform = MethodChannel('com.example.davisProject/');
  ArtworkDetail? selectedArtworkDetail;

  Future<void> openARView(String imagePath, String modelPath) async {
    try {
      await platform.invokeMethod(
          'openARView', {'imagePath': imagePath, 'modelPath': modelPath});
    } on PlatformException catch (e) {
      print("Failed to open AR view: '${e.message}'.");
    }
  }

  Future<void> setSelectedArtworkAndOpenAR(ArtworkDetail artworkDetail) async {
    String imagePath = await downloadFile(artworkDetail.imageDetectionUrl);
    String modelPath = await downloadFile(artworkDetail.usdzUrl);
    openARView(imagePath, modelPath);
  }

  @override
  void initState() {
    super.initState();
    print('Loading URL: ${widget.artwork.lumaUrl}'); // Print the URL
    print(widget.artwork.lumaUrl);

    // Platform-specific controller creation params
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true, // Example iOS-specific setting
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    // Instantiate the WebViewController
    _webController = WebViewController.fromPlatformCreationParams(params);
    // Further settings and loading initial URL
    _webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.artwork.lumaUrl));

    // Platform-specific features (Android in this example)
    if (_webController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
  }

  Future<String> downloadFile(String url) async {
    var response = await http.get(Uri.parse(url));
    String fileName = p.basename(url);
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Future<void> _downloadAndOpenAR() async {
    if (selectedArtworkDetail == null) {
      print("No artwork selected for AR view.");
      return;
    }
    try {
      final modelURLString =
          selectedArtworkDetail!.usdzUrl; // Using the 3D model URL.
      final imageName = selectedArtworkDetail!
          .imageDetectionUrl; // Using the image for AR tracking.

      print(
          "Opening AR view with model: $modelURLString and image: $imageName");
      await platform.invokeMethod('openARView', {
        'modelURLString': modelURLString,
        'imageName': imageName,
      });
    } on PlatformException catch (e) {
      print("Failed to open AR view: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Match the background color
      body: Stack(
        children: [
          const Positioned.fill(
              child: ParticleWidget()), // Ensure this is correctly implemented
          Column(
            children: [
              AppBar(
                title: Text(widget.artwork.artName),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: SizedBox(
                    height: 180, // Keep the WebView height as in your example
                    child: LumaAIWebView(
                        url:
                            "https://lumalabs.ai/embed/e1316b43-d3bf-46c0-8d4d-db357176929d?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false"),
                    // url: widget.artwork.lumaUrl),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.artwork.artworks
                        .map((artworkDetail) => CityArtworkCard(
                              imagePath: artworkDetail.imageUrl,
                              title: artworkDetail.title,
                              description: artworkDetail.description,
                              gradientColor: Color(int.parse(widget
                                  .artwork.gradientColor
                                  .replaceFirst('#', '0xff'))),
                              usdzUrl: artworkDetail.usdzUrl,
                              imageDetectionUrl:
                                  artworkDetail.imageDetectionUrl,
                              onTap: () =>
                                  setSelectedArtworkAndOpenAR(artworkDetail),
                            ))
                        .toList(),
                  ),
                ),
              ),

              // Additional content or actions related to the artwork
            ],
          ),
        ],
      ),
    );
  }
}

class LumaAIWebView extends StatefulWidget {
  final String url; // Add a parameter to pass the URL dynamically

  const LumaAIWebView({Key? key, required this.url}) : super(key: key);

  @override
  _LumaAIWebViewState createState() => _LumaAIWebViewState();
}

class _LumaAIWebViewState extends State<LumaAIWebView> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Platform-specific controller creation params
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    // Instantiate the WebViewController
    _controller = WebViewController.fromPlatformCreationParams(params);

    // Further settings and loading initial URL
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));

    // Platform-specific features (Android in this example)
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
