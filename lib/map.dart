import 'package:flutter/material.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'GoogleMaps/markers.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 40;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(59.259753, 5.207062);

class TheMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<TheMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  //Custom markers
  BitmapDescriptor listenMarker;
  BitmapDescriptor lisboaSoaMarker;

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
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
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
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
      LatLng(currentLocation.latitude, currentLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: lisboaSoaMarker,
        infoWindow: InfoWindow(
          title: "You are here!",
        ),
      ),
      );
      addMarkers("Grindhaug",LatLng(59.258248,5.203139), "Listen", "Grindhag", "Skolen");
    });
  }

  void addMarkers(String markerID,LatLng pos,String type, String Title, String Snippet){
    if(type == "Listen"){
      _markers.add(Marker(
        markerId: MarkerId(markerID),
        position: pos,
        icon: listenMarker, //Should be controlled by the type
        infoWindow: InfoWindow(
          title: Title,
          snippet: Snippet,
        ),
      ),);
    }
    else if(type == "LisboaSoa"){
      _markers.add(Marker(
        markerId: MarkerId(markerID),
        position: pos,
        icon: lisboaSoaMarker, //Should be controlled by the type
        infoWindow: InfoWindow(
          title: Title,
          snippet: Snippet,
        ),
      ),);
    }
  }
}
