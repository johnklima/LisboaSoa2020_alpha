import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



GoogleMapController mapController;

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

  final LatLng _center = const LatLng(38.722586, -9.137905);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
          Firestore.instance.collection("LocationAudio").add(
              {
                "name" : "new data " + incr.toString() ,
                "votes" : incr,
              });

        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                  height: MediaQuery.of(context).size.height / 3,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(target: _center, zoom: 15),
                  )),

              SizedBox(
                  width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                  height: MediaQuery.of(context).size.height / 3,

                  child:
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
                      })

              ),

            ]
        );



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
