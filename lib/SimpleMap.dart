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

class SimpleMap extends StatefulWidget
{

  @override
  _MyMapState createState()  => _MyMapState();
}

class _MyMapState extends State<SimpleMap>
{
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = Set<Marker>();


  //gimme firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Geoflutterfire geo = Geoflutterfire();

  Future<void> _onMapCreated(GoogleMapController controller) async {


    setState(()   {


      //
        final marker = Marker(
          markerId: MarkerId('office.name'),
          position: LatLng(38.720586,  -9.135905),
          infoWindow: InfoWindow(
            title: 'office.name',
            snippet: 'office.address',
          ),
        );
        _markers.add(marker);

    });


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: const LatLng(38.720586,  -9.135905),
            zoom: 15,
          ),
          markers: _markers,
        ),
      ),

    );
  }


  }




