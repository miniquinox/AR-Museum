import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class LumaAIModelScreen extends StatefulWidget {
  @override
  _LumaAIModelScreenState createState() => _LumaAIModelScreenState();
}

class _LumaAIModelScreenState extends State<LumaAIModelScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Platform-specific controller creation params
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true, // Example iOS-specific setting
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    // Instantiate the WebViewController
    _controller = WebViewController.fromPlatformCreationParams(params);

    // Further settings and loading initial URL
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          "https://lumalabs.ai/embed/e1316b43-d3bf-46c0-8d4d-db357176929d?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false"));

    // Platform-specific features (Android in this example)
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive 3D Map'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
