


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
import 'main.dart';

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
io.Directory directory;
bool isPlaying;
AudioPlayer audioPlayer0  ;
AudioPlayer audioPlayer1  ;
AudioPlayer audioPlayer2 ;
AudioPlayer audioPlayer3  ;
AudioPlayer audioPlayer4 ;
AudioPlayer audioPlayer5  ;
AudioPlayer audioPlayer6  ;
AudioPlayer audioPlayer7  ;

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

  print('---------------> init audio' + MyApp().localFileSystem.systemTempDirectory.path);


  try {
    if (await Permission.storage.request().isGranted
        && await Permission.mediaLibrary.request().isGranted
    ) {
      print( "granted ");
      io.Directory appDocDirectory;
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
        directory = appDocDirectory;
        print("the path is " + appDocDirectory.path);
      } else {
        appDocDirectory = await getExternalStorageDirectory();
        directory = appDocDirectory;
        print("the path is " + appDocDirectory.path);
      }
    }
  } catch (e) {
    print(e);
  }

  audioPlayer0 = AudioPlayer();
  audioPlayer1 = AudioPlayer();
  audioPlayer2 = AudioPlayer();
  audioPlayer3 = AudioPlayer();
  audioPlayer4 = AudioPlayer();
  audioPlayer5 = AudioPlayer();
  audioPlayer6 = AudioPlayer();
  audioPlayer7 = AudioPlayer();

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

	print('play the track') ;

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


  /*
  final File file = File( '${MyApp().localFileSystem.systemTempDirectory.path}/$trackName');
  final StorageReference ref = FirebaseStorage.instance.ref().child('${trackName}');
  final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
  final int byteNumber = (await downloadTask.future).totalByteCount;
  return '${MyApp().localFileSystem.systemTempDirectory.path}/$trackName';
  */


print('download the file') ;

  final io.Directory tempDir = directory;
  final File file = File('${tempDir.path}/$trackName');
  final StorageReference ref = FirebaseStorage.instance.ref().child('${trackName}');
  final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
  final int byteNumber = (await downloadTask.future).totalByteCount;
  return '${tempDir.path}/$trackName';


}

Future <int> PressedPlay(trackName) async {

print('pressed play') ;

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
		print('On Tap') ;
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

    firestore
        .collection('LocationAudio')
        .add({'name': 'listen to this', 'position': listenLoc.data, 'Type':'Listen', 'filename': 'blah.m4a'});
*/

/*

///Goethe Institut
  GeoFirePoint eventLocGoethe = geo.point(latitude: 38.721195, longitude:  -9.140714);
  ///estufa fria
  GeoFirePoint eventLocEstufa = geo.point(latitude: 38.7286948, longitude:  -9.1552445);
  ///palacio sinel
  GeoFirePoint eventLocSinel = geo.point(latitude: 38.7160216, longitude:  -9.1251148);
  ///mercado santa clara
  GeoFirePoint eventLocMercado = geo.point(latitude:  38.7155921, longitude:  -9.1254624);
  ///jardim torel
  GeoFirePoint eventLocTorel = geo.point(latitude:  38.7188366, longitude:  -9.1413199);
 ///garagem epal
  GeoFirePoint eventLocGarage = geo.point(latitude:  38.719825, longitude:  -9.119935);
  ///momagua
  GeoFirePoint eventLocMomAgua = geo.point(latitude: 38.7213889, longitude:  -9.1558333);
  ///severa
  GeoFirePoint eventLocSevera = geo.point(latitude: 38.7162605, longitude:  -9.134676);

  GeoFirePoint eventLocTerra = geo.point(latitude: 38.7107456, longitude:  -9.144212);

  GeoFirePoint eventLocMonument = geo.point(latitude:  38.7229825, longitude:  -9.1393342);

  GeoFirePoint eventLocPalacio = geo.point(latitude:  38.758551, longitude:  -9.156418);

  GeoFirePoint eventLocPanteao = geo.point(latitude:  38.7149944, longitude:  -9.1246835);



  firestore
      .collection('LocationAudio')
      .add({'name': 'Performances',
    'position': eventLocMomAgua.data,
    'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/09/logo.png',
    'text' : 'Performances - Mãe d’Água das Amoreiras',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com'});

  firestore
      .collection('LocationAudio')
      .add({'name': 'Performances',
    'position': eventLocEstufa.data,
    'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/09/logo.png',
    'text' : 'Performances - Estufa Fria de Lisboa',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com'});

  firestore
      .collection('LocationAudio')
      .add({'name': 'Performances',
    'position': eventLocPanteao.data,
    'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/09/logo.png',
    'text' : 'Performances - Panteão Nacional',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com'});

  firestore
      .collection('LocationAudio')
      .add({'name': 'Performances',
    'position': eventLocMercado.data,
    'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/09/logo.png',
    'text' : 'Performances - Mercado de Santa Clara',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com'});

   firestore
      .collection('LocationAudio')
      .add({'name': 'Performances',
    'position': eventLocPalacio.data,
    'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/09/logo.png',
    'text' : 'Performances - Museu de Lisboa – Palácio Pimenta',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com'});

  firestore
      .collection('LocationAudio')
      .add({'name': 'Performances',
    'position': eventLocTerra.data,
    'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/09/logo.png',
    'text' : 'Performances - Terraço EPAL, Largo da Anunciada, nº 5',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com'});

 */

  /*
    firestore
        .collection('LocationAudio')
        .add({'name': 'Installation Fictional Forests',
              'position': eventLocSinel.data,
              'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/08/003-019.png',
              'text' : 'Gil Delindro - Palácio Sinel de Cordes',
              'Type':'Event',
              'filename':'https://www.lisboasoa.com/gil-delindro/'});



  firestore
      .collection('LocationAudio')
      .add({'name': 'Installation Coro',
    'position': eventLocEstufa.data,
    'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/08/003-017-1.png',
    'text' : 'Gonçalo Alegria',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com/goncalo-alegria/'});


  firestore
      .collection('LocationAudio')
      .add({'name': 'Installation Echoplastos',
    'position': eventLocMercado.data,
    'imageurl' :'http://www.lisboasoa.com/wp-content/uploads/2020/08/003-015.png',
    'text' : 'Henrique Fernandes e Tiago Ângelo',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com/henrique-fernandes-e-tiago-angelo-2/'});

  firestore
      .collection('LocationAudio')
      .add({'name': 'Installation Corpo Clima',
    'position': eventLocTorel.data,
    'imageurl' :'https://www.lisboasoa.com/wp-content/uploads/2020/08/003-008.png',
    'text' : 'Nuno da Luz - Jardim do Torel',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com/nuno-da-luz/'});


  firestore
      .collection('LocationAudio')
      .add({'name': 'Installation Non-Place',
    'position': eventLocGarage.data,
    'imageurl' :'https://www.lisboasoa.com/wp-content/uploads/2020/08/003-006.png',
    'text' : 'Nuno Mika Garagem EPAL',
    'Type':'Event',
    'filename':'http://www.lisboasoa.com/nuno-mika/'});


  firestore
      .collection('LocationAudio')
      .add({'name': 'Installation llhas – uma constelação',
    'position': eventLocMomAgua.data,
    'imageurl' :'https://www.lisboasoa.com/wp-content/uploads/2020/08/003-004.png',
    'text' : 'Sara Anjo - Mãe d´Água das Amoreiras',
    'Type':'Event',
    'filename':'https://www.lisboasoa.com/sara-anjo/'});


  firestore
      .collection('LocationAudio')
      .add({'name': 'Installation Lisboa Sem Título',
    'position': eventLocSevera.data,
    'imageurl' :'https://www.lisboasoa.com/wp-content/uploads/2020/08/003-002.png',
    'text' : 'Ana Água, Carmo Rolo e Ricardo Guerreiro - Largo da Severa',
    'Type':'Event',
    'filename':''});


*/






/////////////////////////////////////////////////////////////////////////////////////
  /*
  firestore
      .collection('LocationAudio')
      .add({'name': '',
    'position': eventLocSinel.data,
    'imageurl' :'',
    'text' : '',
    'Type':'Event',
    'filename':''});
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
