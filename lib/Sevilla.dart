import 'package:flutter/material.dart';
import 'locations.dart';

class SevillaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocationScreen(
      title: 'Explore Sevilla',
      jsonFile: 'assets/Sevilla.json',
      webViewUrl:
          'https://lumalabs.ai/embed/e1316b43-d3bf-46c0-8d4d-db357176929d?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false',
      gradientColor: const Color.fromARGB(255, 255, 133, 72).withOpacity(0.7),
    );
  }
}
