import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayer extends StatefulWidget {
  @override
  _AudioPlayerState createState() => new _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.white54,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 75,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  color: Colors.deepOrange,
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  color: Colors.black38,
                ),
                Container(
                  height: 75,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  color: Colors.black38,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.amber,
                            margin: EdgeInsets.all(5),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.amber,
                            margin: EdgeInsets.all(5),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.amber,
                            margin: EdgeInsets.all(5),

                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.amber,
                            margin: EdgeInsets.all(5),
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
