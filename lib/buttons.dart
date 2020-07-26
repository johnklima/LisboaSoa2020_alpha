import "package:flutter/material.dart";

//import "event_page.dart";

// Here we can keep all our button widgets, this will help us keep our
// scripts much cleaner.

// Navigates to a new page.
class NavigateTo extends StatelessWidget {
  var pageName;
  String buttonText;
  NavigateTo(this.pageName, this.buttonText);

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
            buttonText,
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

class RecorderButton extends StatelessWidget {
  @override

  final assetImgDir;
  final buttonText;

  RecorderButton(this.buttonText, this.assetImgDir);

  Widget build(BuildContext context) {
    return                 Expanded(
      child: Align(
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: ButtonTheme(
            minWidth: 150,
            height: 50,
            child: RaisedButton(
              color: Colors.white,
              child: Container(
                height: 40,
                width: 175,
                child: Row(
                  children: <Widget>[
                     Container(
                       margin: EdgeInsets.all(10),
                       child : Align(
                        alignment: Alignment.centerLeft,
                        child: Image(

                          image: AssetImage(
                              assetImgDir),
                        ),
                      ),
                     ),

                    Expanded(
                      child: Align(
                        alignment: Alignment(-0.3, 0),
                        child: Text(
                          buttonText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              textColor: Colors.lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () {},
            ),
          ),
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
