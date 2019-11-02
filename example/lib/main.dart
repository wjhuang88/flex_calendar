import 'package:flex_calendar/flex_calendar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flex Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flex Calendar Demo.'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FlexCalendarController calendarController = FlexCalendarController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    calendarController.addSelectListener((date) {
      setState(() {
        _date = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: FlexCalendar(
              height: 400.0,
              controller: calendarController,
              initDate: _date,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text('上月'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: calendarController.goLastMonth,
              ),
              FlatButton(
                child: Text('下月'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: calendarController.goNextMonth,
              ),
              FlatButton(
                child: Text('本月'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => calendarController.goTo(DateTime.now().year, DateTime.now().month),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text('今天'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => calendarController.select(DateTime.now()),
              ),
              FlatButton(
                child: Text('已选'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => calendarController.goTo(_date.year, _date.month),
              ),
              FlatButton(
                child: Text('切换'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                child: Text('选择的日期: ${_date.year}年${_date.month}月${_date.day}日'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
