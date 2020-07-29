import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lisboasoa2020/audioPlayer.dart';

//Internal Packages
import 'buttons.dart';
import 'dataMap.dart';
import 'recorder.dart';
import "calendar.dart";
import 'videoplayer.dart';
import 'firebaseaudio.dart';
import 'website.dart';
import 'map.dart';
import 'audiomap.dart';
import 'record.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

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
          headline2: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          headline3: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.white),
          bodyText1: TextStyle(
            fontFamily: 'Consola',
            fontSize: 25,
            color: Colors.lightGreen,
          ),
          bodyText2: TextStyle(
            fontFamily: 'Consola',
            fontSize: 15,
            color: Colors.white,
          ),
        ),
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
            margin: EdgeInsets.only(top: 60),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
//I have added a buttons.dart where I keep the button widgets,
//NavigateTo is such a button, look in buttons.dart for more.
                    child: NavigateTo(TheMap(true), "listen"),
                  ),
                  Container(
                    child: NavigateTo(Recorder(), "record"),
                  ),
                  Container(
                    child: NavigateTo(Website(), "calendar"),
                  ),
                  Container(
                    child: NavigateTo(TheMap(false), "see"),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 35, 0, 0),
                    child: Image(
                      image: AssetImage(
                          "assets/Logo/LisboaSoa_Logo_Corner_Small.png"),
                      alignment: Alignment.topLeft,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
                    child: Image(
                      image:
                          AssetImage("assets/Graphic/LisboaSoa_Text_Home.png"),
                      alignment: Alignment.topRight,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(20),
            child: Image(
              image:
                  AssetImage("assets/Graphic/LisboaSoa_Text_Bottom_Info.png"),
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
