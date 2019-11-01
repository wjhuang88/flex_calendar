library flex_calendar.widget;

import 'package:flutter/widgets.dart';

import 'flex_calendar_controller.dart';
import 'flex_calendar_state.dart';
import 'type_define.dart';

class FlexCalendar extends StatefulWidget {
  const FlexCalendar({
    Key key,
    this.initDate,
    this.headHeight,
    this.height,
    this.width,
    this.titleBuilder,
    this.headBuilder,
    this.tileBuilder,
    this.onDateChange,
    this.onInitiate,
    this.onDispose,
    this.weekLabels = const ['一', '二', '三', '四', '五', '六', '日'],
    this.controller,
  }) : assert(weekLabels.length == DateTime.daysPerWeek), super(key: key);

  final DateTime initDate;
  final double headHeight;
  final double height;
  final double width;
  final CalenderTitleBuilder titleBuilder;
  final CalenderHeadTileBuilder headBuilder;
  final CalenderBoxBuilder tileBuilder;
  final CalenderAction onDateChange;
  final CalenderAction onInitiate;
  final CalenderAction onDispose;
  final List<String> weekLabels;
  final FlexCalendarController controller;

  @override
  FlexCalendarState createState() => FlexCalendarState();
}