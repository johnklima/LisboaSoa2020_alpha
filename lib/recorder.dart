import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:uuid/uuid.dart';

//Project Packages
import 'audioFiles.dart';

class AudioRecorder extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<AudioRecorder> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: new ExampleRecorder(),
        ),
    );
  }
}

class ExampleRecorder extends StatefulWidget {
  final LocalFileSystem localFileSystem;

// Calls a function from a imported package to get the local directory.
  ExampleRecorder({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new RecorderExampleState();
}

class RecorderExampleState extends State<ExampleRecorder> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  String guid;
  Position pos;
  String dur;
  String loc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(2.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Text("Status : $_currentStatus"),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new FlatButton(
                      onPressed: () {
                        switch (_currentStatus) {
                          case RecordingStatus.Initialized:
                            {
                              _start();
                              break;
                            }
                          case RecordingStatus.Recording:
                            {
                              _pause();
                              break;
                            }
                          case RecordingStatus.Paused:
                            {
                              _resume();
                              break;
                            }
                          case RecordingStatus.Stopped:
                            {
                              _init();
                              break;
                            }
                          default:
                            break;
                        }
                      },
                      child: buildText(_currentStatus),
                      color: Colors.lightBlue,
                    ),
                  ),
                  new FlatButton(
                    onPressed:
                    _currentStatus != RecordingStatus.Unset ? _stop : null,
                    child:
                    new Text("Stop", style: TextStyle(color: Colors.white)),
                    color: Colors.blueAccent.withOpacity(0.5),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  new FlatButton(
                    onPressed: onPlayAudio,
                    child:
                    new Text("Play", style: TextStyle(color: Colors.white)),
                    color: Colors.blueAccent.withOpacity(0.5),
                  ),

                  new FlatButton(
                    onPressed: saveToJson,
                    child:
                    new Text("Save", style: TextStyle(color: Colors.white)),
                    color: Colors.blueAccent.withOpacity(0.5),
                  ),


                ],
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: Colors.redAccent),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom:  5,
                            left: 30,
                            right: 30,
                          ),
                          child: new Text('Avg Power:'),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom:  5,
                            left: 30,
                            right: 30,
                          ),
                          child: new Text('Peak Power:'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.redAccent),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom:  5,
                            left: 30,
                            right: 30,
                          ),
                          //child: new Text(_current?.metering?.averagePower?.toStringAsFixed(1)),
                          child: new Text('Avg Power: ${_current?.metering?.averagePower?.toStringAsFixed(1)}'),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            bottom:  5,
                            left: 30,
                            right: 30,
                          ),
                          //child: new Text(_current?.metering?.peakPower?.toStringAsFixed(1)),
                          child: new Text('Peak Power: ${_current?.metering?.peakPower?.toStringAsFixed(1)}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              new Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom:  2,
                      left: 10,
                      right: 10,
                    ),

                    child: new Text("File path",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom:  5,
                      left: 10,
                      right: 10,
                    ),
                    child: new Text("${_current?.path}",
                    style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom:  5,
                      left: 10,
                      right: 10,
                    ),
                    child: new Text(
                        "Audio recording duration : ${_current?.duration.toString()}")
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom:  5,
                      left: 10,
                      right: 10,
                    ),
                    child: new Text("Format : ${_current?.extension}"),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  _init() async {

    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        pos = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        Guid iD = Guid.newGuid;
        guid = iD.value;
        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        loc = appDocDirectory.path +
            "/" + guid;

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(loc);
        //_current.path = customPath;

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
    // ignore: null_aware_before_operator
        if (_current?.duration?.inSeconds > 30.00){
          _stop();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      dur = _current?.duration.toString();
    });
  }

  Widget buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Record';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Init';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }

  void saveToJson(){
   AudioFiles audioFiles =  AudioFiles(guid, pos.toString(), dur, loc);
   print(audioFiles.toJson());
  }


}