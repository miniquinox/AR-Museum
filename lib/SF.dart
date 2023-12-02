import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../ar_image_tracking_page.dart'; // Ensure this import is correct
import 'package:webview_flutter/webview_flutter.dart';

class SanFranciscoScreen extends StatefulWidget {
  @override
  _SanFranciscoScreenState createState() => _SanFranciscoScreenState();
}

class _SanFranciscoScreenState extends State<SanFranciscoScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  List<dynamic>? artworks; // Make this nullable

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://dms.licdn.com/playlist/vid/C5605AQEvMacH4az7Rg/mp4-720p-30fp-crf28/0/1614364548556?e=1701910800&v=beta&t=1q8dAEAgYXJ34JgT911Rjbp2paa7BGwKsq1jawE7BPE',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    loadArtworkData();
  }

  Future<void> loadArtworkData() async {
    String jsonString = await rootBundle.loadString('assets/SF.json');
    final jsonResponse = json.decode(jsonString);
    setState(() {
      artworks = [];
      jsonResponse.forEach((key, value) {
        artworks!.add(value);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore San Francisco'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                height: 300,
                child: WebView(
                  initialUrl:
                      "https://lumalabs.ai/embed/e1316b43-d3bf-46c0-8d4d-db357176929d?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false",
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_controller.value.isInitialized) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          if (artworks != null)
                            for (var artwork in artworks!)
                              ArtworkCard(
                                imagePath: artwork['image'],
                                title: artwork['title'],
                                description: artwork['description'],
                              ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ImageDetectionPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.orangeAccent,
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              child: const Text(
                                "Start your Adventure",
                                style: TextStyle(color: Colors.orangeAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                        child: Text('Error initializing video player.'));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class ArtworkCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const ArtworkCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the gradient colors and stops
    final gradientColors = [
      Colors.transparent,
      const Color.fromARGB(255, 116, 48, 242).withOpacity(0.7),
    ];
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
              // Center the title
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
                textAlign:
                    TextAlign.center, // Center align the description if needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
