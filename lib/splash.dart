import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'main.dart';
import 'particles.dart'; // Import the particles file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
          Column(
            // Ensures that the app bar and content are on top of the effects
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: SizedBox(
                    height: 300,
                    child: WebViewWidget(
                        controller:
                            _webController), // Updated to WebViewWidget// Updated to WebViewWidget
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
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
              const SizedBox(height: 60),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        25), // match this with the button's border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(
                            0.6), // adjust color and opacity as needed
                        spreadRadius: 5, // adjust spread radius as needed
                        blurRadius: 7, // adjust blur radius as needed
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                    onPressed: () {
                      // Implement Google sign-in logic
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent, // Text color
                      shape: const StadiumBorder(), // Rounded corners
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        25), // match this with the button's border radius
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(137, 168, 168,
                            168), // adjust color and opacity as needed
                        spreadRadius: 5, // adjust spread radius as needed
                        blurRadius: 7, // adjust blur radius as needed
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.apple),
                    label: const Text('Sign in with Apple'),
                    onPressed: () {
                      // Implement Apple sign-in logic
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black, // Text color
                      shape: const StadiumBorder(), // Rounded corners
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              )
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
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            }, // Smaller icon
            backgroundColor: Colors.purpleAccent,
            mini: true,
            child: const Icon(Icons.skip_next, size: 24), // Smaller button
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .miniStartFloat, // Position to the bottom left
    );
  }
}
