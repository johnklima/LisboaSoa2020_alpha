import 'dart:async';
//import 'dart:convert'; // not sure if this is needed.
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_guid/flutter_guid.dart';

import 'package:firebase_storage/firebase_storage.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:geoflutterfire/geoflutterfire.dart';
//import 'package:file_picker/file_picker.dart';

import 'buttons.dart';
import 'main.dart';
//import 'audioFiles.dart';

class Recorder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RecorderState();
}

class _RecorderState extends State<Recorder> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  AudioPlayer audioPlayer = AudioPlayer();

//FireStore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  io.File file;

  var DocDir;
  var isPlaying;
  var recordingName;

  // variables stored for sending to the json on save.
  String guid;
  Position pos;
  String dur;
  String loc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Hello");
    _init();
  }

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
                    child : Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextField(
                        maxLength: 20,
                        onChanged:(text) {
                          setState(() {
                            recordingName = text;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Recording Name.."
                        ),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
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
                                alignment: Alignment(-0.17, -0.0),
                                width: double.infinity,
                                height: double.infinity,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: ImageRotate("assets/Graphic/LisboaSoa_Graphic_AudioPlayer_LeftFan_2.png", isPlaying),
                                  /*Image(
                                    image: AssetImage(
                                        "assets/Graphic/LisboaSoa_Graphic_AudioPlayer_LeftFan.png"),
                                  ),
                                   */
                                ),
                              ),
                            ),
                            Expanded(
                              /// The right fan on the audio player
                              child: Container(
                                alignment: Alignment(0.17, -0.0),
                                width: double.infinity,
                                height: double.infinity,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child:
                                  ImageRotate("assets/Graphic/LisboaSoa_Graphic_AudioPlayer_LeftFan_2.png", isPlaying),
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
                        child: new Text(
                            "${_current?.duration?.toString()}",
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

                        recordButton(),

                            //"record", 'assets/Icons/LisboaSoa_Icon_Record.png', this


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

  Widget recordButton() {

    var _widgetToReturn = RecorderButton(
        "new", 'assets/Icons/LisboaSoa_Icon_Record.png', this
    );

    if (_currentStatus == RecordingStatus.Initialized){
      _widgetToReturn = RecorderButton(
          "record", 'assets/Icons/LisboaSoa_Icon_Record.png', this
      );
    }
    else if (_currentStatus == RecordingStatus.Recording){
      _widgetToReturn = RecorderButton(
          "pause", 'assets/Icons/LisboaSoa_Icon_Record.png', this
      );
    }
    else if (_currentStatus == RecordingStatus.Paused){
      _widgetToReturn = RecorderButton(
          "resume", 'assets/Icons/LisboaSoa_Icon_Record.png', this
      );
    }
    else if (_currentStatus == RecordingStatus.Stopped){
      _widgetToReturn = RecorderButton(
          "new", 'assets/Icons/LisboaSoa_Icon_Record.png', this
      );
    }
    return _widgetToReturn;
  }

  void theOnPress(String st){
    if (st == "record"){
      _start();
    } else if (st == "stop"){
      _currentStatus != RecordingStatus.Unset ? _stop() : null;
    } else if (st == "play"){
      onPlayAudio();
    } else if (st == "save"){
      saveToJson();
    } else if (st == "pause"){
      _pause();
    } else if (st == "resume"){
      _resume();
    } else if (st == "new"){
      _init();
    }
  }

  //Function for initiating a new recording, making a new guid etc.
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

        //pos = await Geolocator()
        //    .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        Guid iD = Guid.newGuid;
        guid = iD.value;
        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        loc = appDocDirectory.path + "/" + guid;

        DocDir = appDocDirectory.path;
        print("This is the Doc Dir !!!! " + DocDir);

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = FlutterAudioRecorder(loc);
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

  //Starts recording the audio, this loops while user is recording.
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

        // if statement to stop recording if it goes over 30 sec.

        // ignore: null_aware_before_operator
        if (_current?.duration?.inSeconds > 30.00) {
          _stop();
        }

      });
    } catch (e) {
      print(e);
    }
  }

  //Resumes the recording
  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  //Pauses the recording
  _pause() async {
    await _recorder.pause();
    setState(() {});
  }
  //Stops the recording and stores it in the local drive.
  //Perhaps move this to the "Save" function.
  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    file = MyApp().localFileSystem.file(result.path);
    //print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      dur = _current?.duration.toString();
    });

    if (audioPlayer.state == AudioPlayerState.PLAYING){
      audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }

  }

  //Play the recorder audio.
  //This is what we should use in the audio lib I suppose.
  void onPlayAudio() async {
    setState(() {
      isPlaying = true;
    });
    if (audioPlayer.state == AudioPlayerState.PLAYING){
      audioPlayer.stop();
    }
    await audioPlayer.play(_current.path, isLocal: true);

  }

  //Save function, currently only stores the info in the json file.
  //I haven't really found the json file yet so I am not sure if it works,
  //or if this is the correct way to send it to the json.
  void saveToJson() {

    if (recordingName == null){
      print(recordingName);
    }
    else{
      print(recordingName);

      GeoFirePoint position = geo.point(latitude: pos.latitude, longitude: pos.longitude);


      firestore
          .collection('LocationAudio')
          .add({'name': recordingName , 'position': {'geohash': position.hash, 'geopoint' : position.geoPoint}, 'Type':'Listen', 'filename': guid});

      uploadFile();
    }
    //var collectionReference = firestore.collection('LocationAudio');

    //AudioFiles audioFiles = AudioFiles(guid, pos.toString(), dur, loc);
    //print(audioFiles.toJson());
  }
  /// work in progress file upload.

    Future uploadFile() async {

      StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(guid);
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
    });
  }
}


