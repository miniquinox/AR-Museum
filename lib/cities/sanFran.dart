import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ar_image_tracking_page.dart'; // Ensure this import is correct

class SanFran extends StatefulWidget {
  @override
  _SanFranState createState() => _SanFranState();
}

class _SanFranState extends State<SanFran> {
  bool _scrollable = true;
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('San Francisco'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        controller: controller,
        physics: _scrollable
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('images/golden_gate.png'),
              ),
              SizedBox(height: 16),
              _buildSection(
                title: 'Theme',
                icon: Icons.color_lens_outlined,
                content:
                    'Dive into the realm of the abstract, now brought to life like never before! Using cutting-edge Augmented Reality (AR) technology, our museum offers a transformative experience that blurs the lines between art and reality. Come, immerse yourself in a world where imagination meets innovation.',
                color: Colors.greenAccent,
              ),
              _buildSection(
                title: 'Artists',
                icon: Icons.brush_outlined,
                content:
                    'Joaquin Carretero, a maestro in Software Graphics, previously honed his expertise at Meta Reality Labs. His profound journey in the world of graphics steered him to a new passion—creating art. Today, he unveils his masterpieces, a symphony of art and technology, for the world to witness.',
                color: Colors.blueAccent,
              ),
              _buildSection(
                title: 'Location',
                icon: Icons.map_outlined,
                content:
                    'Embark on an artistic hunt across the iconic Golden Gate Park, San Francisco. Our museum unfolds across seven distinct locations within the park. Each spot is a chapter, a piece of the puzzle, beckoning you to explore and discover. Ready for the adventure?',
                color: Colors.pinkAccent,
              ),
              // Removed SizedBox to reduce space
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageDetectionPage()),
                    );
                  },
                  child: Text(
                    "Start your Adventure",
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.orangeAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // ... Other widgets if any
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[900],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
