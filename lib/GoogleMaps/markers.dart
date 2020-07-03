//External Packages
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:lisboasoa2020/dataMap.dart';

class StaticMarkers {

  final Set<Marker> markers = {

    Marker(
      markerId: MarkerId("Future Event"),
      position: const LatLng(38.720586, -9.134905),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(
        title: "This is a future event",
        snippet: "this event will happen in the future",
      ),
    ),

    Marker(
      markerId: MarkerId("Ongoing Event"),
      position: const LatLng(38.720586, -9.136905),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(
        title: "This event is happening now",
        snippet: "Ongoing event, YOU BETTER RUN !",
      ),
    ),

    Marker(
      markerId: MarkerId("Even is over"),
      position: const LatLng(38.720586, -9.138905),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        onTap: () { Map().EnterEventPage(); },
        title: "This event is over",
        snippet: "You didn't make it .. ",
      ),
    ),

    Marker(
      markerId: MarkerId("Recorded Sound"),
      position: const LatLng(38.722586, -9.136905),
      icon: BitmapDescriptor.fromAsset("assets/ListenToThis_Placeholder.png"),
      infoWindow: InfoWindow(
        title: "Listen to this sound",
        snippet: "but no sound was to be heard",
      ),
    ),
  };
}



