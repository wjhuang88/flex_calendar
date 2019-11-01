library flex_calendar.controller;

import 'flex_calendar_state.dart';

class FlexCalendarController {
  FlexCalendarState _state;

  // 注入FlexCalendarState对象时由其将自身赋值于此.
  set state(FlexCalendarState value) => _state = value;

  double get animValue => _state.animValue;

  // 方法委托，注入FlexCalendarState对象时由其实现.
  void Function() goLastMonth = (){};
  void Function() goNextMonth = (){};
  void Function(int year, int month) goTo = (_, __){};
}