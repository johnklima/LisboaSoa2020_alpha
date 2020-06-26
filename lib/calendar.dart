import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'buttons.dart';
import 'main.dart';
import 'buttons.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CalendarPage(title: 'Event Calendar'),
    );
  }
}

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<CalendarPage> {
  DateTime _currentDate = DateTime(2020, 9, 1);
  DateTime _currentDate2 = DateTime(2020, 9, 1);
  String _currentMonth = DateFormat.yMMM().format(DateTime(2020, 9, 1));
  DateTime _targetDateTime = DateTime(2020, 9, 1);
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2020, 09, 05): [
        new Event(
          date: new DateTime(2020, 09, 05),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.blue,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2020, 9, 11),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2020, 9, 11),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        new DateTime(2020, 9, 03),
        new Event(
          date: new DateTime(2020, 9, 03),
          title: 'Event 1',
          icon: _eventIcon,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        // events.forEach((event) {if (event.date == date){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => EventPage()));
        //} });
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.date));
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 300.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
      CircleBorder(side: BorderSide(color: Colors.red)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
      todayButtonColor: Colors.red,
      selectedDayTextStyle: TextStyle(
        color: Colors.red,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );


    return new Scaffold(
      appBar: new AppBar(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //custom icon
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: _calendarCarousel,
            ), // This trailing comma makes auto-formatting nicer for build methods.
            //custom icon without header
            Container(
              margin: EdgeInsets.only(
                top: 30.0,
                bottom: 5.0,
                left: 16.0,
                right: 16.0,
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                        _currentMonth,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      )),
                  FlatButton(
                    child: Text('PREV'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month - 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                      });
                    },
                  ),
                  FlatButton(
                    child: Text('NEXT'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month + 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              child: _calendarCarouselNoHeader,
            ), //
          ],
        ),
      ),
        );
  }
}

class Cal extends StatefulWidget {
  @override
  _CalState createState() => _CalState();
}

class _CalState extends State<Cal> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
