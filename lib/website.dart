import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

//To the Home Page

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

// To an Event Page

class EventPage extends StatefulWidget {
  @override

  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: new EventPagePage(),
      ),
    );
  }
}

class EventPagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebView(
        /// This should be changed to return the relevant artist or event.
        initialUrl: 'http://www.lisboasoa.com/program2020/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
