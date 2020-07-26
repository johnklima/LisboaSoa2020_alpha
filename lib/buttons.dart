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

  String assetImgDir;
  String buttonText;

  RecorderButton(this.buttonText, this.assetImgDir);

  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        child: Container(
          height: 50,
          width: 200,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: Image(
                  image: AssetImage(
                      assetImgDir),
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
