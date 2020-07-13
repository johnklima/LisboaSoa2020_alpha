//External Packages
import 'package:flutter/material.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/widgets.dart';

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
        primarySwatch: Colors.lightGreen,

        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.bold,
            color: Colors.lightGreen,

          ),
        )

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
      // List View widget seams like a nice menu widget,
      // this is very basic and can be customized a lot further.

      //https://api.flutter.dev/flutter/widgets/ListView-class.html
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/Graphic/LisboaSoa_Background.png"),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fitWidth,
          ),

          Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(

//I have added a buttons.dart where I keep the button widgets,
//NavigateTo is such a button, look in buttons.dart for more.
                    child: NavigateTo(DataAndMap()),
                  ),
                  Container(

                    child: NavigateTo(AudioRecorder()),
                  ),
                  Container(
                    child: NavigateTo(Calendar()),
                  ),
                  Container(
                    child: NavigateTo(VideoPlayerScreen()),
                  ),
                  Container(
                    child: NavigateTo(FireAudio()),
                  ),
                  Container(
                    child: NavigateTo(Website()),
                  ),
                ],
              ),
            ),
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
/*
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
*/
