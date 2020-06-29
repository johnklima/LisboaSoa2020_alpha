import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:audioplayer2/audioplayer2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class FireAudio extends StatefulWidget {
  @override
  FireAudioState createState() => new FireAudioState();
}

class FireAudioState extends State<FireAudio> {
  // List tracks = ["one", "track1", "track2", "track3", "track4"]; // note: each track button should now be rendered based on tracks within within Firebase database/Firestore

  @override
  initState() {
    super.initState();
  }

  onPressed(trackName) async {
    var track = await downloadFile(trackName); // should replace track2 with trackName which should be the contents(text) of the button
    playTrack(track);
  }

  Future<void> playTrack(track) async { // may not need to be a future
    AudioPlayer audioPlayer = new AudioPlayer();
    await audioPlayer.play(track);
  }

  Future<String> downloadFile(String trackName) async {
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/${trackName}');
    final StorageReference ref = FirebaseStorage.instance.ref().child('${trackName}');
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
    final int byteNumber = (await downloadTask.future).totalByteCount;
    return '/data/user/0/com.cityarts.lisboasoa2020/cache/${trackName}';
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

