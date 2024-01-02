import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../ar_image_tracking_page.dart';
import 'timer_service.dart';
import 'package:provider/provider.dart';

bool isPurchaseComplete = false;
DateTime? purchaseTime;
Timer? globalTimer;
Duration timeLeft =
    Duration(hours: 23, minutes: 59, seconds: 59); // Initialize to 9:59

String getImagePathForLocation(String locationId) {
  switch (locationId) {
    case 'San Francisco':
      return 'images/golden_gate.jpeg';
    case 'Sevilla':
      return 'images/sevilla.jpeg';
    case 'New York':
      return 'images/central_park.jpeg';
    // Add more cases as needed
    default:
      return 'images/AR_Museum_icon.png'; // Default image path
  }
}

void resetTimer() {
  timeLeft = Duration(hours: 23, minutes: 59, seconds: 59);
}

void startGlobalTimer() {
  // Cancel the existing timer if it is already running
  if (globalTimer != null && globalTimer!.isActive) {
    globalTimer!.cancel();
  }

  globalTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
    if (timeLeft.inSeconds == 0) {
      isPurchaseComplete = false;
      timer.cancel();
    } else {
      timeLeft = Duration(seconds: timeLeft.inSeconds - 1);
    }

    // Check if LocationScreen is active and update it
    if (_LocationScreenState.currentInstance?.mounted ?? false) {
      _LocationScreenState.currentInstance!.updateTimer();
    }
  });
}

class LocationScreen extends StatefulWidget {
  final String title;
  final String jsonFile;
  final String webViewUrl;
  final Color gradientColor;

  const LocationScreen({
    Key? key,
    required this.title,
    required this.jsonFile,
    required this.webViewUrl,
    required this.gradientColor,
  }) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<dynamic>? artworks;
  late WebViewController _webController;
  static _LocationScreenState? currentInstance;

  @override
  void initState() {
    super.initState();
    currentInstance = this;
    loadArtworkData();
    if (isPurchaseComplete && (globalTimer == null || !globalTimer!.isActive)) {
      startGlobalTimer();
    }

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _webController = WebViewController.fromPlatformCreationParams(params);
    _webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.webViewUrl));

    if (_webController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
  }

  void updateTimer() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadArtworkData() async {
    String jsonString = await rootBundle.loadString(widget.jsonFile);
    final jsonResponse = json.decode(jsonString);
    setState(() {
      artworks = jsonResponse
          .map((key, value) => MapEntry(key, value))
          .values
          .toList();
    });
  }

  @override
  void dispose() {
    // Dispose of your resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: SizedBox(
                  height: 300,
                  child: WebViewWidget(controller: _webController),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: artworks
                          ?.map((artwork) => ArtworkCard(
                                imagePath: artwork['image'],
                                title: artwork['title'],
                                description: artwork['description'],
                                gradientColor: widget.gradientColor,
                              ))
                          .toList() ??
                      [],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Consumer<TimerService>(
          builder: (context, timerService, child) => Container(
            width: 140,
            height: 56,
            child: FloatingActionButton.extended(
              onPressed: () {
                if (!timerService.isPurchaseComplete(widget.title)) {
                  // Retrieve the corresponding image path for the location
                  String imagePath = getImagePathForLocation(widget.title);

                  // Start the timer with the location ID and image path
                  timerService.startTimer(widget.title, imagePath);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImageDetectionPage()),
                  );
                }
              },
              backgroundColor: Colors.amber[600],
              icon: timerService.isPurchaseComplete(widget.title)
                  ? const Icon(Icons.camera_alt)
                  : null,
              label: timerService.isPurchaseComplete(widget.title)
                  ? Text(
                      timerService.getFormattedTimeLeft(widget.title),
                      style: const TextStyle(fontSize: 16),
                    )
                  : const Text('Purchase'),
            ),
          ),
        ));
  }
}

class DummyPaymentScreen extends StatelessWidget {
  final VoidCallback onComplete;

  DummyPaymentScreen({required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Purchase')),
      body: Center(
          child: ElevatedButton(
        child: Text('Complete Purchase'),
        onPressed: () {
          final timerService =
              Provider.of<TimerService>(context, listen: false);
          String locationId =
              "YourLocationIdentifier"; // Replace with actual identifier
          String imagePath = getImagePathForLocation(locationId);
          timerService.startTimer(locationId, imagePath);
          onComplete();
          Navigator.pop(context);
        },
      )),
    );
  }
}

class ArtworkCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Color gradientColor;

  const ArtworkCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.gradientColor,
  });

  @override
  Widget build(BuildContext context) {
    // Define the gradient colors and stops
    final gradientColors = [Colors.transparent, gradientColor.withOpacity(0.7)];
    final gradientStops = [0.5, 1.0]; // Adjust to have the gradient start later

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
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
              Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
