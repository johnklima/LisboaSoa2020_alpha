


library my_prj.globals;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:io' as io;

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_storage/firebase_storage.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import 'map.dart' as themap;

import "GoogleMaps/MapDesign.dart";

var url = '';

final Set<Marker> _Lmarkers = Set<Marker>();
final Set<Marker> _Emarkers = Set<Marker>();

FirebaseFirestore firestore;
Geoflutterfire geo;
///Custom markers
BitmapDescriptor listenMarker;
BitmapDescriptor lisboaSoaMarker;

//gimme an audio player
var directory;
bool isPlaying;
AudioPlayer audioPlayer0 = AudioPlayer();
AudioPlayer audioPlayer1 = AudioPlayer();
AudioPlayer audioPlayer2 = AudioPlayer();
AudioPlayer audioPlayer3 = AudioPlayer();
AudioPlayer audioPlayer4 = AudioPlayer();
AudioPlayer audioPlayer5 = AudioPlayer();
AudioPlayer audioPlayer6 = AudioPlayer();
AudioPlayer audioPlayer7 = AudioPlayer();

int curAudioPlayer = 0;

var eventOverlay;
var eventName;
var eventUrl;
String eventImage;
String eventText;

themap.MapState mapState;

/// This is the same function that is called in "recorder.dart"
/// it collects the devices directory, should perhaps be made into its
/// own dart file so it can be called when it's needed and only be
/// called once ?.
initAudio() async {
  try {
    if (await Permission.storage.request().isGranted
        && await Permission.mediaLibrary.request().isGranted
    ) {
      io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
        directory = appDocDirectory;
        print(directory);
      } else {
        appDocDirectory = await getExternalStorageDirectory();
        directory = appDocDirectory;
        print(directory);
      }
    }
  } catch (e) {
    print(e);
  }
}

Future<void> playTrack(track) async {// may not need to be a future

  ///TODO:
  ///<JPK> we will need an isplaying array, or a class or something so we can
  ///start and stop multiple audio files.
  ///OR simplest thing is no stop at all, just play play play.

  /// added a simple if check to make the audio stop when pressed again.
  /// also moved the AudioPlayer up so that it wouldn't create a new
  /// reference for each time we called it. (this what caused the
  /// audio going on top of each other.
  ///
  ///
  /// just play
  if (curAudioPlayer == 0)
    await audioPlayer0.play(track, isLocal: true);

  if (curAudioPlayer == 1)
    await audioPlayer1.play(track, isLocal: true);

  if (curAudioPlayer == 2)
    await audioPlayer2.play(track, isLocal: true);

  if (curAudioPlayer == 3)
    await audioPlayer3.play(track, isLocal: true);

  if (curAudioPlayer == 4)
    await audioPlayer4.play(track, isLocal: true);

  if (curAudioPlayer == 5)
    await audioPlayer5.play(track, isLocal: true);

  if (curAudioPlayer == 6)
    await audioPlayer6.play(track, isLocal: true);

  if (curAudioPlayer == 7)
    await audioPlayer7.play(track, isLocal: true);


  curAudioPlayer++;
  if(curAudioPlayer > 7)
    curAudioPlayer = 0;

  /*
    if (!isPlaying){
      await audioPlayer.play(track, isLocal: true);
      isPlaying = true;
    }
    else{
      await audioPlayer.stop();
      isPlaying = false;
    }

     */
}

Future<String> downloadFile(String trackName) async {


  ///try to just hardcode the url
  ///

  return "https://firebasestorage.googleapis.com/v0/b/applied-tractor-279610.appspot.com/o/" + trackName;
  final Directory tempDir = directory;
  final File file = File('${tempDir.path}/$trackName');
  final StorageReference ref = FirebaseStorage.instance.ref().child('${trackName}');
  final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
  final int byteNumber = (await downloadTask.future).totalByteCount;
  return '${tempDir.path}/$trackName';
}

Future <int> PressedPlay(trackName) async {
  var track = await downloadFile(trackName); // should replace track2 with trackName which should be the contents(text) of the button
  playTrack(track);
  return 1;
}

void loadStuff()
{
  _Lmarkers.clear();
  _Emarkers.clear();

  //gimme firestore
   firestore = FirebaseFirestore.instance;

   geo = Geoflutterfire();

   initAudio();
   loadCustomIcons();
   setSourceAndDestinationIcons();


}
Set<Marker> getLMarkers()
{
 return _Lmarkers;
}
Set<Marker> getEMarkers()
{
  return _Emarkers;
}
void loadCustomIcons() async
{

  listenMarker =  await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 5),
      'assets/MapMarkers/LisboaSoa_ListenMarker_Small.png')
      .then((onValue) {
    return onValue;
  });


  lisboaSoaMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 5),
      'assets/MapMarkers/LisboaSoa_SoaMarker_Small.png')
  // ignore: missing_return
      .then((value) {
    return value;
  });

}




/// The map marker types
Marker addMarkers(
    String markerID, LatLng pos, String type, String Title, String Snippet, String image, String text)
{

  if (type == "Listen")
  {
    print("ADD MARKER " + Title);
    print("LOC " + pos.latitude.toString() + " " + pos.longitude.toString());
    print(Snippet);

    final marker = Marker(
      markerId: MarkerId(markerID),
      position: pos,
      icon: listenMarker == null
          ? BitmapDescriptor.defaultMarker
          : listenMarker, //Should be controlled by the type

      infoWindow: InfoWindow(
          title: Title,

          onTap: () {
            PressedPlay(Snippet);
          }
      ),
    );
    _Lmarkers.add(marker);
  }

  if (type == "Event")
  {
    print("ADD MARKER " + Title);
    print("LOC " + pos.latitude.toString() + " " + pos.longitude.toString());

    final marker = Marker(
      markerId: MarkerId(markerID),
      position: pos,
      icon: listenMarker == null
          ? BitmapDescriptor.defaultMarker
          : lisboaSoaMarker, //Should be controlled by the type

      infoWindow: InfoWindow(
          title: Title,

          onTap: () {
            print("Pushed the map button");
            eventName = Title;
            eventUrl = Snippet;
            eventImage = image;
            eventText = text;
            eventOverlay = true;
            mapState.showEventBox();
          }
      ),
    );
    _Emarkers.add(marker);
  }
}

void setSourceAndDestinationIcons()  {

  //<JPK> just hacking around here to try to make connection to database
  //below adds to the db
/*
    GeoFirePoint listenLoc = geo.point(latitude: 38.720586, longitude: -9.135905);
    GeoFirePoint eventLoc = geo.point(latitude: 38.720586, longitude:  -9.137905);
    firestore
        .collection('LocationAudio')
        .add({'name': 'listen to this', 'position': listenLoc.data, 'Type':'Listen', 'filename': 'blah.m4a'});

    firestore
        .collection('LocationAudio')
        .add({'name': 'cool happening', 'position': eventLoc.data,'Type':'Event', 'filename': 'woof.m4a'});
  */

  //code below reads from the db, and makes new markers?
  // Create a geoFirePoint for our current location (hacked for now)
  GeoFirePoint center = geo.point(latitude: 38.720586, longitude: -9.134905);

// get the collection reference or query
  var collectionReference = firestore.collection('LocationAudio');

  double radius = 500000;
  String field = 'position';


  Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: collectionReference)
      .within(center: center, radius: radius, field: field);

  stream.listen((List<DocumentSnapshot> documentList) {
    //add the markers
    for(final document in documentList) {
      //documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data()['position']['geopoint'];
      String name = document.data()['name'];
      String type = document.data()['Type'];
      String filename = document.data()['filename'];
      String image = document.data()['imageurl'];
      String text = document.data()['text'];
      String iD = document.id.toString();
      //need to sort which marker i suppose
      addMarkers(iD, LatLng(pos.latitude, pos.longitude), type, name,
          filename, image, text);

    }
  });

}
