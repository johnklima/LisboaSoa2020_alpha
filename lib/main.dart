import 'package:flutter/material.dart';
/*void main() {
  runApp(const MyApp());
}
*/

//Custom Packages
import 'buttons.dart';
import 'dataMap.dart';
import 'recorder.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {


    return MaterialApp(

      title: 'Lisboa Soa 2020',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: HomePage(),

      /*
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 20.0,
          ),
        ),
      ),
      */
    );
  }

  }

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 80,
            color: Colors.yellow[100],
            child: NavigateTo(DataAndMap()),
          ),
          Container(
            height: 80,
            color: Colors.yellow[200],
            child: NavigateTo(AudioRecorder()),
          ),
        ],
      ),
    );
  }
}

