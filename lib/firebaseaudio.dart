import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audio_cache.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:lisboasoa2020/recorder.dart';

class FireAudio extends StatefulWidget {

  @override
  FireAudioState createState() => new FireAudioState();
}

class FireAudioState extends State<FireAudio> {

  var directory;

  bool isPlaying;

  @override
  initState() {
    super.initState();
    _init();
  }

  onPressed(trackName) async {
    var track = await downloadFile(trackName); // should replace track2 with trackName which should be the contents(text) of the button
    playTrack(track);
  }

  Future<void> playTrack(track) async { // may not need to be a future

    debugPrint(track);

    AudioPlayer audioPlayer = AudioPlayer();

    await audioPlayer.play(track, isLocal: true);

  }

  _init() async {
    try {
      if (await Permission.storage.request().isGranted
      && await Permission.mediaLibrary.request().isGranted
      ) {
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
          directory = appDocDirectory;
        } else {
          appDocDirectory = await getExternalStorageDirectory();
          directory = appDocDirectory;
          print(directory);
        }
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> downloadFile(String trackName) async {
    final Directory tempDir = directory;

    final File file = File('${tempDir.path}/$trackName');
    debugPrint('track:${trackName}');
    final StorageReference ref = FirebaseStorage.instance.ref().child('${trackName}');
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
    final int byteNumber = (await downloadTask.future).totalByteCount;
    return '${tempDir.path}/$trackName';
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
        title:
        Card(
          child: RaisedButton(child: Text(document['name']),
              color: Colors.purple,
              onPressed: () => onPressed(document['name'])),
        )
    );
  }

  @override
  Widget build(context) {
    return  Scaffold(
        appBar: AppBar(
          title:  Text("Firesound"),
        ),
        body:
        StreamBuilder(
            stream: Firestore.instance.collection("LocationAudio").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text("Track are loading...");
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index])
              );
            }
        )
    );
  }
}

