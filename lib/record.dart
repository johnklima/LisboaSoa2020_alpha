import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Recorder extends StatefulWidget {
  @override
  _RecorderState createState() => new _RecorderState();
}

class _RecorderState extends State<Recorder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          AppBar(),
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
                      child: Container(
                        height: 140,
                        width: 275,


                        child: Image(
                          image: AssetImage(
                              "assets/Graphic/LisboaSoa_Graphic_AudioPlayer.png"),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 140,
                        width: 275,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment(-0.17, -0.05),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Image(

                                      image: AssetImage(
                                          "assets/Graphic/LisboaSoa_Graphic_AudioPlayer_LeftFan.png"),

                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  alignment: Alignment(0.17, -0.05),
                                  child: Container(
                                    height: 50,
                                    width: 50,
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
                Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        child: Text("audio recording duration",
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Text("00:00:00",
                            style: Theme.of(context).textTheme.headline2),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            child: Container(
                              height: 50,
                              width: 200,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Image(
                                      image: AssetImage(
                                          "assets/Icons/LisboaSoa_Icon_Record.png"),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment(-0.3, 0),
                                      child: Text(
                                        "record",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                          child: Container(
                            height: 50,
                            width: 200,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/Icons/LisboaSoa_Icon_Stop.png"),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment(-0.3, 0),
                                    child: Text(
                                      "stop",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                          child: Container(
                            height: 50,
                            width: 200,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/Icons/LisboaSoa_Icon_Play.png"),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment(-0.3, 0),
                                    child: Text(
                                      "play",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                          child: Container(
                            height: 50,
                            width: 200,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/Icons/LisboaSoa_Icon_Save.png"),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment(-0.3, 0),
                                    child: Text(
                                      "save",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              ],
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
          ),
        ],
      ),
    );
  }
}
