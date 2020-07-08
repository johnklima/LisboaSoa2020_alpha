import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Website extends StatefulWidget {
  @override
  _WebsiteState createState() => _WebsiteState();
}

class _WebsiteState extends State<Website> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: new WebsitePage(),
        ),
    );
  }
}

class WebsitePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebView(
        initialUrl: 'https://www.lisboasoa.com/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
