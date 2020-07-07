//External Packages
import 'package:flutter/material.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

//Internal Packages
import 'buttons.dart';
import 'dataMap.dart';
import 'recorder.dart';
import "calendar.dart";
import 'videoplayer.dart';
import 'firebaseaudio.dart';
import 'website.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lisboa Soa 2020',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),

      /*
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 20.0,
          ),
        ),
      ),
      */
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      // List View widget seams like a nice menu widget,
      // this is very basic and can be customized a lot further.

      //https://api.flutter.dev/flutter/widgets/ListView-class.html
      body: ListView(
        children: <Widget>[
          Container(
            height: 80,
            color: Colors.yellow[100],
            //I have added a buttons.dart where I keep the button widgets,
            //NavigateTo is such a button, look in buttons.dart for more.
            child: NavigateTo(DataAndMap()),
          ),
          Container(
            height: 80,
            color: Colors.yellow[200],
            child: NavigateTo(AudioRecorder()),
          ),
          Container(
            height: 80,
            color: Colors.yellow[3 + 00],
            child: NavigateTo(Calendar()),
          ),
          Container(
            height: 80,
            color: Colors.yellow[3 + 00],
            child: NavigateTo(VideoPlayerScreen()),
          ),
          Container(
            height: 80,
            color: Colors.yellow[3 + 00],
            child: NavigateTo(FireAudio()),
          ),
          Container(
            height: 80,
            color: Colors.yellow[3 + 00],
            child: NavigateTo(Website()),
          ),
        ],
      ),
    );
  }
}

/// Under here seems to not be of use and is only stored
/// in case it is needed

/*
final LocalFileSystem localFileSystem;
// Calls a function from a imported package to get the local directory.
MyApp({localFileSystem})
    : this.localFileSystem = localFileSystem ?? LocalFileSystem();
*/
