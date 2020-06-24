import "package:flutter/material.dart";

//import "event_page.dart";

// Here we can keep all our button widgets, this will help us keep our
// scripts much cleaner.


// Navigates to a new page.
class NavigateTo extends StatelessWidget {
  var pageName;
  NavigateTo(this.pageName);

  @override
  Widget build(BuildContext context) {
    //The container info might be best to keep in the other widget
    //rather than in here, perhaps change this to only a Raised Button.
    return Container(
      margin: EdgeInsets.only(
      top: 20,
      bottom:  20,
      left: 100,
      right: 100,
    ),

      child: RaisedButton(
        color: Colors.lightBlueAccent[100],
        child: Text(pageName.toString()),
        textColor: Colors.black45,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pageName),
          );
        },
      ),
    );
  }
}

/// This is the correct way to go back to the previous page
/// but it's not working when having the widget in here for
/// some reason.
class NavigateBack extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(

      child: RaisedButton(
        child: Text("Go Back"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
