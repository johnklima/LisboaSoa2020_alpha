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
  final buttonClass;

  RecorderButton(this.buttonText, this.assetImgDir,this.buttonClass);

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
              onPressed: () {
                buttonClass.theOnPress(buttonText);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ImageRotate extends StatefulWidget {

  final imageLoc;
  final isPlaying;
  ImageRotate(this.imageLoc,this.isPlaying);

  @override
  _ImageRotateState createState() => new _ImageRotateState(imageLoc,isPlaying);
}

class _ImageRotateState extends State<ImageRotate>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  final imageLoc;
  final isPlaying;

  _ImageRotateState(this.imageLoc, this.isPlaying);

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 7),
    );
    if(isPlaying != null && isPlaying){
      animationController.repeat();
    }
    else{
      animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,

      child: new AnimatedBuilder(
        animation: animationController,
        child: new Container(
          height: 150.0,
          width: 150.0,
          child: new Image.asset(imageLoc),
        ),
        builder: (BuildContext context, Widget _widget) {
          return new Transform.rotate(
            angle: animationController.value * 6.3,
            child: _widget,
          );
        },
      ),
    );
  }
}