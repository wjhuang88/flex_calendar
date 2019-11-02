library flex_calendar.controller;

import 'package:flutter/widgets.dart';

import 'flex_calendar_state.dart';

class FlexCalendarController extends ValueNotifier<DateTime> {
  FlexCalendarState _state;

  FlexCalendarController() : super(null);
  FlexCalendarController.of(DateTime date) : super(date);

  void addSelectListener(void Function(DateTime) callback) {
    assert(callback != null);
    addListener(() => callback(value));
  }

  // 注入FlexCalendarState对象时由其将自身赋值于此.
  set state(FlexCalendarState newState) => _state = newState;

  double get animValue => _state.animValue;
  DateTime get selectedDate => _state.selectedDate;

  // 方法委托，注入FlexCalendarState对象时由其实现.
  VoidCallback goLastMonth = (){};
  VoidCallback goNextMonth = (){};
  void Function(int year, int month) goTo = (_, __){};
  void Function(DateTime date) select = (_){};
}