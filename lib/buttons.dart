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
      margin: EdgeInsets.all(15),
      child: ButtonTheme(
        minWidth: 250,
        height: 60,
        child: RaisedButton(
          color: Colors.white,
          child: Text(
              pageName.toString(),
          style: Theme.of(context).textTheme.bodyText1,

          ),

          textColor: Colors.lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => pageName),
            );
          },
        ),
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
