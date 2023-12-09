import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'main.dart';
import 'particles.dart'; // Import the particles file

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  late WebViewController _webController;

  @override
  void initState() {
    super.initState();
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
      ..loadRequest(Uri.parse(
          "https://lumalabs.ai/embed/a6435014-c193-4872-af93-b5c4e360a58c?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false"));

    if (_webController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
  }

  Widget _buildShineEffect() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.8), // Position of the light source
            radius: 1.0, // Radius of the effect
            colors: [
              Colors.white.withOpacity(0.3), // Brightness of the shine
              Colors.transparent,
            ],
            stops: [0.0, 0.6], // Spread of the shine
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Museum'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: ParticleWidget()), // Particle effect
          _buildShineEffect(), // Shine of light effect
          Column(
            // Ensures that the app bar and content are on top of the effects
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    height: 300,
                    child: WebViewWidget(
                        controller:
                            _webController), // Updated to WebViewWidget// Updated to WebViewWidget
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Explore the world of augmented reality and discover unique artworks in the AR Museum. Sign in to start your adventure!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.blueAccent,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 60),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                  onPressed: () {
                    // Implement Google sign-in logic
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent, // Background color
                    onPrimary: Colors.white, // Text color
                    shape: StadiumBorder(), // Rounded corners
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                    shadowColor: Colors.blueAccent,
                    elevation: 15,
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.apple),
                    label: const Text('Sign in with Apple'),
                    onPressed: () {
                      // Implement Apple sign-in logic
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Background color
                      onPrimary: Colors.white, // Text color
                      shape: StadiumBorder(), // Rounded corners
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                      shadowColor: Colors.black,
                      elevation: 15,
                    ),
                  ))
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            },
            child: const Icon(Icons.skip_next, size: 24), // Smaller icon
            backgroundColor: Colors.purpleAccent,
            mini: true, // Smaller button
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .miniStartFloat, // Position to the bottom left
    );
  }
}
