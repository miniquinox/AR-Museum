import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import the Google Maps Flutter package
import 'package:google_fonts/google_fonts.dart';

class NYCScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New York City')),
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
                  SizedBox(height: 16),
                  Text(
                    'Theme',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'This is a simple description of what we will be writing in the theme of the month of this museum'),
                  SizedBox(height: 16),
                  Text(
                    'Artists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'Quino is the upcoming artist that will be joining us today, all the way from Spain.'),
                  SizedBox(height: 16),
                  Text(
                    'Location',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'The event will take place at the entrance of central park. Please reach out to event organizer for more info'),
                  SizedBox(height: 16),
                  // This Container will house the Google Map
                  Container(
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(37.7684,
                            -122.4936), // Coordinates for Hellman Hollow Picnic Area
                        zoom: 16.0, // Adjusting the zoom level
                      ),
                      markers: {
                        Marker(
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
