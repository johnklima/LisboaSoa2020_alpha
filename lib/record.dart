import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'buttons.dart';
import 'recorder.dart';

class Recorder extends StatefulWidget {
  @override
  _RecorderState createState() => new _RecorderState();
}

class _RecorderState extends State<Recorder> {

  final recorder = new ExampleRecorder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          AppBar(),

          /// Background image.
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: const DecorationImage(
                  image: AssetImage("assets/Graphic/LisboaSoa_Background.png"),
                  fit: BoxFit.cover),
            ),
          ),

          /// The is playing bar on top.
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              children: <Widget>[
                Container(
                  height: 75,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "Playing this audio..",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                Stack(
                  children: <Widget>[
                    Center(
                      /// The audio player
                      child: Container(
                        height: 120,
                        width: 250,
                        child: Image(
                          image: AssetImage(
                              "assets/Graphic/LisboaSoa_Graphic_AudioPlayer.png"),
                        ),
                      ),
                    ),

                    /// This is both fans on the audio payer
                    Center(
                      child: Container(
                        /// Has to be the same as the audio player height & width
                        height: 120,
                        width: 250,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              /// The left fan on the audio player
                              child: Container(
                                alignment: Alignment(-0.17, -0.05),
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/Graphic/LisboaSoa_Graphic_AudioPlayer_LeftFan.png"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              /// The right fan on the audio player
                              child: Container(
                                alignment: Alignment(0.17, -0.05),
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/Graphic/LisboaSoa_Graphic_AudioPlayer_RightFan.png"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(

                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                    ),
                    Center(
                      /// static information text
                      child: Container(
                        child: Text("audio recording duration",
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ),
                    Center(
                      /// time audio has been played.
                      child: Container(
                        child: Text("00:00:00",
                            style: Theme.of(context).textTheme.headline2),
                      ),
                    ),
                  ],
                ),
                /// The buttons on the bottom.
                /// The widget for these can be found in
                /// buttons.dart
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        RecorderButton(
                            "record", 'assets/Icons/LisboaSoa_Icon_Record.png', this
                        ),

                        RecorderButton(
                            "stop", 'assets/Icons/LisboaSoa_Icon_Stop.png', this
                        ),
                        RecorderButton(
                            "play", 'assets/Icons/LisboaSoa_Icon_Play.png', this
                        ),
                        RecorderButton(
                            "save", 'assets/Icons/LisboaSoa_Icon_Save.png', this
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void theOnPress(String st){
    if (st == "record"){
      print(st);
      
    } else if (st == "stop"){
      print(st);
    } else if (st == "play"){
      print(st);
    } else if (st == "save"){
      print(st);
    }
  }
}
