import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
//import 'package:lisboasoa2020/buttons.dart';
//import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'website.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import "GoogleMaps/MapDesign.dart";

const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 40;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(38.720586, 9.134905);
var listen;

class TheMap extends StatefulWidget {

  final lis;
  TheMap(this.lis);

  @override
  State<StatefulWidget> createState() {
    listen = lis;
   return new MapState();
  }
}

class MapState extends State<TheMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  ///Custom markers
  BitmapDescriptor listenMarker;
  BitmapDescriptor lisboaSoaMarker;

 //gimme firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Geoflutterfire geo = Geoflutterfire();

  //gimme an audio player
  var directory;
  bool isPlaying;

  AudioPlayer audioPlayer = AudioPlayer();

  var eventOverlay;
  var eventName;
  //Current user location
  LocationData currentLocation;

  // wrapper around the location API
  Location location;

  var closestPoint;

  @override
  void initState() {
    super.initState();



    print(listen);
    location = new Location();
    print("INIT STATE");
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;

      updatePinOnMap();
    });

    setInitialLocation();
    initAudio();
    setSourceAndDestinationIcons();
    isPlaying = false;

  }

  void setSourceAndDestinationIcons() async {


    listenMarker =  await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/MapMarkers/LisboaSoa_ListenMarker_Small.png')
        .then((onValue) {
      return onValue;
    });


    lisboaSoaMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/MapMarkers/LisboaSoa_SoaMarker_Small.png')
    // ignore: missing_return
        .then((value) {
      return value;
    });

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
      documentList.forEach((DocumentSnapshot document) {
        GeoPoint pos = document.data()['position']['geopoint'];
        String name = document.data()['name'];
        String type = document.data()['Type'];
        String filename = document.data()['filename'];
        String iD = document.id.toString();
        //need to sort which marker i suppose
        addMarkers(iD, LatLng(pos.latitude, pos.longitude), type, name,
            filename);
      });


    });

  }

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
  PressedPlay(trackName) async {
    var track = await downloadFile(trackName); // should replace track2 with trackName which should be the contents(text) of the button
    playTrack(track);
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

    await audioPlayer.play(track, isLocal: true);
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
    final Directory tempDir = directory;
    final File file = File('${tempDir.path}/$trackName');
    final StorageReference ref = FirebaseStorage.instance.ref().child('${trackName}');
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
    final int byteNumber = (await downloadTask.future).totalByteCount;
    return '${tempDir.path}/$trackName';
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(38.720586, 9.134905),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                if (listen){
                  controller.setMapStyle(UtilsYellow.mapStyles);
                }
                else{
                  controller.setMapStyle(UtilsBlue.mapStyles);
                }
                _controller.complete(controller);
                // my map has completed being created;
                // i'm ready to show the pins on the map
                showPinsOnMap();
              }),
          TheEventPage(eventOverlay, this, eventName),
        ],
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    // get a LatLng out of the LocationData object
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon:lisboaSoaMarker == null?BitmapDescriptor.defaultMarker : lisboaSoaMarker ));



    // destination pin
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation

    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      // the trick is to remove the marker (by id)
      // and add it again at the updated location

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(
        Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
            icon:lisboaSoaMarker == null?BitmapDescriptor.defaultMarker : lisboaSoaMarker ,
          infoWindow: InfoWindow(
            title: "You are here!",
          ),
        ),
      );
    });
  }

  /// The map marker types
  void addMarkers(
      String markerID, LatLng pos, String type, String Title, String Snippet) {

    if (listen && type == "Listen") {
        print("ADD MARKER " + Title);
        _markers.add(
        Marker(
          markerId: MarkerId(markerID),
          position: pos,
          icon: listenMarker == null?BitmapDescriptor.defaultMarker : listenMarker, //Should be controlled by the type

          infoWindow: InfoWindow(
            title: Title,

            onTap: (){
              PressedPlay(Snippet);
            }
          ),
        ),
      );
    } else if (!listen && type == "Event") {
      print("ADD MARKER " + Title);
      _markers.add(
        Marker(
          markerId: MarkerId(markerID),
          position: pos,
          icon: lisboaSoaMarker == null?BitmapDescriptor.defaultMarker : lisboaSoaMarker, //Should be controlled by the type
          onTap: () {
            print("Pushed the map button");
            setState(() {
              eventName = Title;
              eventOverlay = true;
            });
          },
        ),
      );
    }
  }

  void backButton() {
    setState(() {
      eventOverlay = false;
    });
  }

  void eventWebPage()  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventPage()),
    );
  }
}

class TheEventPage extends StatelessWidget {

  final active;
  final mapState;
  final eventName;
  

  TheEventPage(this.active, this.mapState, this.eventName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:((() {
        if (active != null  && active) {
          return Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black38,
              ),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: const DecorationImage(
                      image: AssetImage("assets/Graphic/LisboaSoa_Background.png"),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.white60,
                      width: 8,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  /// This is the event page, should be moved into a separate
                  /// .dart file, and just called in from there.
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 300,
                        height: 200,
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 50,
                              margin: EdgeInsets.all(5),
                              child: Center(
                                child: Container(
                                  child: Text(
                                    eventName,
                                    style: Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 130,
                              margin: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      color: Colors.white30,
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          "A small summary about the artist in here...",
                                          style:
                                          Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: const DecorationImage(
                                          image: NetworkImage('https://www.lisboasoa.com/wp-content/uploads/2020/08/banner.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(
                                          color: Colors.white60,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: RaisedButton(
                                      color: Colors.white,
                                      child: Text(
                                        "Back",
                                        style:
                                        Theme.of(context).textTheme.bodyText1,
                                      ),
                                      textColor: Colors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      onPressed: () {
                                        mapState.backButton();
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: RaisedButton(
                                      color: Colors.white,
                                      child: Text(
                                        "More",
                                        style:
                                        Theme.of(context).textTheme.bodyText1,
                                      ),
                                      textColor: Colors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      onPressed: () {
                                        mapState.eventWebPage();
                                      },
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
          );
        }
        return Container();
      })()),);
  }
}

