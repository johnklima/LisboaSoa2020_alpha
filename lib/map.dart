
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

import 'globals.dart' as globals;

const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 40;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(38.720586, -9.134905);
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
  //Set<Marker> _markers = Set<Marker>();


  ///Custom markers
  BitmapDescriptor listenMarker;
  BitmapDescriptor lisboaSoaMarker;

 //gimme firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Geoflutterfire geo = Geoflutterfire();


  var eventOverlay;
  var eventName;
  var eventUrl;
  var eventImage;
  var eventText;

  //Current user location
  LocationData currentLocation;

  // wrapper around the location API
  Location location;

  var closestPoint;

  @override
  void initState() {
    super.initState();

    globals.mapState = this;



    print(listen);
    location = new Location();
    print("INIT STATE");
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();


    });

    setInitialLocation();

    //setSourceAndDestinationIcons();



    globals.mapState = this;



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
          target: LatLng(38.720586, -9.134905),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

   Set<Marker> markers = Set<Marker>();

  if(listen)
    markers = globals.getLMarkers();
  else
    markers = globals.getEMarkers();

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              markers:markers , //globals.getMarkers(),
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
          TheEventPage(globals.eventOverlay, this, globals.eventName, globals.eventUrl, globals.eventImage, globals.eventText),
        ],
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition = LatLng(38.720586, -9.134905);

    if(currentLocation != null)
      pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    // get a LatLng out of the LocationData object
    // add the initial source location pin
    globals.getLMarkers().add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon:globals.lisboaSoaMarker == null?BitmapDescriptor.defaultMarker : globals.lisboaSoaMarker ));

    globals.getEMarkers().add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon:globals.lisboaSoaMarker == null?BitmapDescriptor.defaultMarker : globals.lisboaSoaMarker ));


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
      var pinPosition = LatLng(38.720586, -9.134905);

      if(currentLocation != null)
        pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location

      globals.getLMarkers().removeWhere((m) => m.markerId.value == 'sourcePin');
      globals.getEMarkers().removeWhere((m) => m.markerId.value == 'sourcePin');

      globals.getLMarkers().add(
        Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
            icon:globals.lisboaSoaMarker == null?BitmapDescriptor.defaultMarker : globals.lisboaSoaMarker ,
          infoWindow: InfoWindow(
            title: "You are here!",
          ),
        ),
      );

      globals.getEMarkers().add(
        Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon:globals.lisboaSoaMarker == null?BitmapDescriptor.defaultMarker : globals.lisboaSoaMarker ,
          infoWindow: InfoWindow(
            title: "You are here!",
          ),
        ),
      );

    });
  }


  void showEventBox()
  {
    setState(() {
      eventName = globals.eventName;
      eventUrl = globals.eventUrl;
      eventImage = globals.eventImage;
      eventText = globals.eventText;
      eventOverlay = globals.eventOverlay;
    });
  }
  void backButton() {
    globals.eventOverlay = false;
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
  final eventUrl;
  final eventImage;
  final eventText;
  

  TheEventPage(this.active, this.mapState, this.eventName, this.eventUrl, this.eventImage, this.eventText);

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
                                          eventText,
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
                                        image: DecorationImage(
                                          image: NetworkImage(eventImage),
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
                                        globals.url = eventUrl;
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

