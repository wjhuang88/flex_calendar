library flex_calendar.type;

import 'package:flutter/widgets.dart';

const pageHugeOffset = 9999999;

enum TileState {
  inactive, active, selected
}

typedef CalenderTitleBuilder = Widget Function(BuildContext context, DateTime selectedDate, DateTime currentDate, double animValue);
typedef CalenderHeadTileBuilder = Widget Function(BuildContext context, String weekName, TileState state, double animValue);
typedef CalenderBoxBuilder = Widget Function(BuildContext context, DateTime date, TileState state, double animValue);
typedef CalenderAction = void Function(DateTime date);