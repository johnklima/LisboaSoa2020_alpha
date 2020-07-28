import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lisboasoa2020/buttons.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'website.dart';

import 'audioPlayer.dart';
import 'GoogleMaps/mapEventPage.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 40;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(38.720586, -9.134905);

class TheMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<TheMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  ///Custom markers
  BitmapDescriptor listenMarker;
  BitmapDescriptor lisboaSoaMarker;

  var eventOverlay;

  //Current user location
  LocationData currentLocation;

  // wrapper around the location API
  Location location;

  var closestPoint;

  @override
  void initState() {
    super.initState();

    location = new Location();

    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
    });
    setSourceAndDestinationIcons();
    setInitialLocation();
  }

  void setSourceAndDestinationIcons() async {
    print(
        "Should Place the markers Should Place the markers Should Place the markers Should Place the markers Should Place the markers ");
    listenMarker = await BitmapDescriptor.fromAssetImage(
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
    addMarkers("Listen", LatLng(38.720586, -9.134905), "Listen",
        "Listen to this sound", "Sound");
    addMarkers(
        "Event", LatLng(38.720586, -9.136905), "LisboaSoa", "Event", "Event");
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
                _controller.complete(controller);
                // my map has completed being created;
                // i'm ready to show the pins on the map
                showPinsOnMap();
              }),
          Text((() {
            if (eventOverlay != null  && eventOverlay) {
              return "tis true";
            }
            return "anything but true";
          })()),
          TheEventPage(eventOverlay , this),
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
        icon: lisboaSoaMarker));
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
          icon: lisboaSoaMarker,
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
    if (type == "Listen") {
      _markers.add(
        Marker(
          markerId: MarkerId(markerID),
          position: pos,
          icon: listenMarker, //Should be controlled by the type
          infoWindow: InfoWindow(
            title: Title,
            snippet: Snippet,
          ),
        ),
      );
    } else if (type == "LisboaSoa") {
      _markers.add(
        Marker(
          markerId: MarkerId(markerID),
          position: pos,
          icon: lisboaSoaMarker, //Should be controlled by the type
          onTap: () {
            print("Pushed the map button");
            setState(() {
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


  TheEventPage(this.active, this.mapState);

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
                                    "The Band",
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
                                          "Info info info info info info"
                                              " info info info info info"
                                              " info info info info info"
                                              " info info info info info",
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
                                          image: AssetImage(
                                              "assets/ListenToThis_Placeholder.png"),
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
