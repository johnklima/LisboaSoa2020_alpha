import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

GoogleMapController mapController;

// This is just copied over from your original code, I added a new
// class to start the page instead of keeping it in the main.dart

// DataAndMap name should be changed, I agree !
class DataAndMap extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<DataAndMap> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: new DataMap(),
      ),
    );
  }
}

class DataMap extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();

  //Map start-up location
  final LatLng _center = const LatLng(38.722586, -9.137905);

  //Markers (Turn this into a own .dart file that works with json.
  final Set<Marker> _markers = {
    Marker(
      rotation: 34,
      markerId: MarkerId("Marker1"),
      position: const LatLng(38.722586, -9.137905),
      infoWindow: InfoWindow(
        title: "Its the first Marker",
        snippet: "marker is first place",
      ),
  ),
    Marker(
      markerId: MarkerId("Marker2"),
      position: const LatLng(38.725586, -9.137905),
      infoWindow: InfoWindow(
        title: "Its the second Marker",
        snippet: "marker is second place",
      ),
  ),
    Marker(
      markerId: MarkerId("Marker3"),
      position: const LatLng(38.725586, -9.134905),
      infoWindow: InfoWindow(
        title: "Its the third Marker",
        snippet: "marker is third place",
      ),
  ),
    Marker(
      markerId: MarkerId("YourPosition"),


      infoWindow: InfoWindow(
        title: "You Are Here",
        snippet: "This is where you are!",
      ),
  ),
  };

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffddddff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              document['votes'].toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ],
      ),
      onTap: () {
        //dirty the file again :)
        int incr = 0;
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap =
              await transaction.get(document.reference);
          await transaction.update(freshSnap.reference, {
            'votes': freshSnap['votes'] + 1,
          });
          incr = freshSnap['votes'];
          //add document?
          Firestore.instance.collection("LocationAudio").add({
            "name": "new data " + incr.toString(),
            "votes": incr,
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: MediaQuery.of(context).size.width, // or use fixed size like 200
        height: MediaQuery.of(context).size.height / 3,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              markers: _markers,
              //mapType: MapType.normal,
              initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            ),
          ],
        ),
        /*
                  child:


                  )*/
      ),
      SizedBox(
          width:
              MediaQuery.of(context).size.width, // or use fixed size like 200
          height: MediaQuery.of(context).size.height / 3,
          child: StreamBuilder(
              stream:
                  Firestore.instance.collection('LocationAudio').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return ListView.builder(
                  itemExtent: 80.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]),
                );
              })),
    ]);

    /*
      StreamBuilder(
          stream: Firestore.instance.collection('LocationAudio').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
      */
  }

}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
