import 'package:flutter/material.dart';




class EventMap extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Hello Wold"),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text("Return"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Center(
        child: Container(
          width: 250,
          height: 350,
          margin: const EdgeInsets.all(30.0),
          color: Colors.blueAccent[100],
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.all(10.0),
                child: RaisedButton(
                  child: Text("Return"),
                  onPressed: () {isActive = false;}
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
  }

 */
}
