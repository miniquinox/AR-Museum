import 'package:flutter/material.dart';
import 'ar_image_tracking_page.dart'; // Import the ARImageTrackingPage

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARKit Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ARKit Flutter Demo'),
      ),
      body: Center(
        child: Sample(
          'AR Image Tracking',
          'Detects an image and places a 3D object.',
          Icons.camera,
          () => Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (context) => ImageDetectionPage()),
          ),
        ),
      ),
    );
  }
}

class Sample extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  Sample(this.title, this.description, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 100.0),
          Text(title, style: Theme.of(context).textTheme.headline5),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
