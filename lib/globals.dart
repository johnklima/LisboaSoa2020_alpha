


library my_prj.globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'website.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
var url = '';

final Set<Marker> _markers = Set<Marker>();
FirebaseFirestore firestore;
Geoflutterfire geo;

void loadStuff()
{
  _markers.clear();

  //gimme firestore
   firestore = FirebaseFirestore.instance;

   geo = Geoflutterfire();

  setSourceAndDestinationIcons();


}
Set<Marker> getMarkers()
{
 return _markers;
}
/// The map marker types
void addMarkers(
    String markerID, LatLng pos, String type, String Title, String Snippet)
{


  print("ADD MARKER " + Title);
  print("LOC " + pos.latitude.toString() + " " + pos.longitude.toString() );

  final marker = Marker(
    markerId: MarkerId(markerID),
    position: pos,
    //icon: listenMarker == null?BitmapDescriptor.defaultMarker : listenMarker, //Should be controlled by the type

    infoWindow: InfoWindow(
        title: Title,

        onTap: (){
          //PressedPlay(Snippet);
        }
    ),
  );
  _markers.add(marker);
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
      String iD = document.id.toString();
      //need to sort which marker i suppose
      addMarkers(iD, LatLng(pos.latitude, pos.longitude), type, name,
          filename);
    }

  });
}
