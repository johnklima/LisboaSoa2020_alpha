//import 'package:flutter/material.dart';
import 'dart:async';
//import 'dart:io';
//import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';



///This is only used to play audio in the app.

class TheAudioPlayer {

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playTrack(track) async {// may not need to be a future
    /// added a simple if check to make the audio stop when pressed again.
    /// also moved the AudioPlayer up so that it wouldn't create a new
    /// reference for each time we called it. (this what caused the
    /// audio going on top of each others
    await audioPlayer.play(track, isLocal: true);
    }
  }
/// on pressed waits until file has been downloaded and then plays it.
  /*
  onPressed(trackName) async {
    var track = await downloadFile(trackName); // should replace track2 with trackName which should be the contents(text) of the button
    playTrack(track);
  }

   */


/*
  Future<String> downloadFile(String trackName) async {
    final Directory tempDir = directory;
    final File file = File('${tempDir.path}/$trackName');
    final StorageReference ref = FirebaseStorage.instance.ref().child('${trackName}');
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
    final int byteNumber = (await downloadTask.future).totalByteCount;
    return '${tempDir.path}/$trackName';

 */


  ///Widget that makes up the button to play the fire audio.
/*
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
 */
/// Widget that builds the builds a list of buttons for all the audio files
  /// that can be found in the fire database.
  /*
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

   */

  ///Gets permission to use the phone directory ?
  /*
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

   */
