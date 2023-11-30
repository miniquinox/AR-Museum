import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SanFranciscoScreen extends StatefulWidget {
  const SanFranciscoScreen({Key? key}) : super(key: key);

  @override
  _SanFranciscoScreenState createState() => _SanFranciscoScreenState();
}

class _SanFranciscoScreenState extends State<SanFranciscoScreen> {
  late VideoPlayerController _controller;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('videos/san_francisco.mp4')
      ..initialize().then((_) {
        setState(() {});
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
        title: const Text('Explore San Francisco'),
      ),
      body: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          const SizedBox(height: 16),
          ExplorationOptions(),
          const Divider(),
          PaginationSection(
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
          ArtworkDescription(currentPage: _currentPage),
          // Add other widgets or functionality as needed
        ],
      ),
    );
  }
}

class ExplorationOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Add exploration options here, similar to the screenshot
        ],
      ),
    );
  }
}

class PaginationSection extends StatelessWidget {
  final Function(int) onPageChanged;

  const PaginationSection({Key? key, required this.onPageChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with your pagination logic, for example, using a PageView.builder
    return Container(); // Placeholder for pagination logic
  }
}

class ArtworkDescription extends StatelessWidget {
  final int currentPage;

  const ArtworkDescription({Key? key, required this.currentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        // Replace with your description text for the current page
        'Artwork #$currentPage Description...',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
