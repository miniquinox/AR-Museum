import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import the Google Maps Flutter package
import 'package:google_fonts/google_fonts.dart';

class NYCScreen extends StatelessWidget {
  const NYCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New York City')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/nyc.png'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New York City',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dancingScript(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Theme',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                      'This is a simple description of what we will be writing in the theme of the month of this museum'),
                  const SizedBox(height: 16),
                  const Text(
                    'Artists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                      'Quino is the upcoming artist that will be joining us today, all the way from Spain.'),
                  const SizedBox(height: 16),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                      'The event will take place at the entrance of central park. Please reach out to event organizer for more info'),
                  const SizedBox(height: 16),
                  // This Container will house the Google Map
                  SizedBox(
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(37.7684,
                            -122.4936), // Coordinates for Hellman Hollow Picnic Area
                        zoom: 16.0, // Adjusting the zoom level
                      ),
                      markers: {
                        const Marker(
                          markerId: MarkerId('hellman_hollow'),
                          position: LatLng(37.7684,
                              -122.4936), // Coordinates for Hellman Hollow Picnic Area
                          infoWindow:
                              InfoWindow(title: 'Hellman Hollow Picnic Area'),
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
