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
            height: 450.0,
            child: FlexCalendar(
              controller: calendarController,
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
                child: Text('今天'),
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
                child: Text('关闭'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {},
              ),
              FlatButton(
                child: Text('展开'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
