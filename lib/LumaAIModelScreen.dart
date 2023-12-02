import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LumaAIModelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Luma AI 3D Model'),
      ),
      body: WebView(
        initialUrl:
            "https://lumalabs.ai/embed/e1316b43-d3bf-46c0-8d4d-db357176929d?mode=sparkles&background=%23ffffff&color=%23000000&showTitle=true&loadBg=true&logoPosition=bottom-left&infoPosition=bottom-right&cinematicVideo=undefined&showMenu=false",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
