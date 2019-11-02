library flex_calendar.state;

import 'package:flutter/widgets.dart';

import 'flex_calendar_controller.dart';
import 'flex_calendar_widget.dart';
import 'type_define.dart';

class FlexCalendarState extends State<FlexCalendar> {

  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;
  CalenderTitleBuilder _titleBuilder;
  CalenderHeadTileBuilder _headBuilder;
  CalenderBoxBuilder _tileBuilder;

  PageController _pageController;
  int _initYear;
  int _initMonth;
  DateTime _pageDate;

  double _animValue = 1.0;
  double get animValue => _animValue;
  double _currentPageValue = pageHugeOffset.toDouble();
  double _prevPageValue;

  FlexCalendarController _controller;

  @override
  void initState() {
    super.initState();

    final pageDuration = Duration(milliseconds: 1000);
    final pageCurve = Cubic(0,1,.55,1);

    _pageController = PageController(initialPage: pageHugeOffset);
    _pageController.addListener(() {
      final pageValue = _pageController.page;
      final pageValueOffset = pageValue - (_prevPageValue ?? pageHugeOffset);
      _prevPageValue = pageValue;
      setState(() {
        _currentPageValue = pageValue;
      });
      final position = _currentPageValue.floor();
      final left = pageValueOffset < 0;
      if (position == _currentPageValue) {
        _animValue = left ? -1.0 : 1.0;
      } else {
        final animOffset = _currentPageValue - position;
        _animValue = left
            ? animOffset - 1
            : animOffset;
      }
    });
    _selectedDate = widget.initDate ?? widget.controller?.value ?? DateTime.now();

    _controller = widget.controller ?? FlexCalendarController.of(_selectedDate);
    _controller.state = this;

    _controller.goLastMonth = () => _pageController.previousPage(
        duration: pageDuration, curve: pageCurve);
    _controller.goNextMonth = () => _pageController.nextPage(
        duration: pageDuration, curve: pageCurve);
    _controller.goTo = (year, month) {
      final offset = (year - _initYear) * 12 + month - _initMonth;
      _pageController.animateToPage(offset + pageHugeOffset, duration: pageDuration, curve: pageCurve);
    };
    _controller.select = (date) {
      _controller.goTo(date.year, date.month);
      setState(() {
        _selectedDate = date;
      });
      // 触发回调事件
      _controller.value = _selectedDate;
    };

    _initYear = _selectedDate.year;
    _initMonth = _selectedDate.month;
    _pageDate = DateTime(_initYear, _initMonth);

    _titleBuilder = widget.titleBuilder ?? (context, selectedDate, pageDate, animValue) {
      final offset = animValue < 0 ? -1 - animValue : 1 - animValue;
      return Container(
        alignment: Alignment.center,
        height: 40.0,
        child: Transform.translate(
          offset: Offset(offset * 200, 0.0),
          child: Opacity(
            opacity: 1 - offset.abs(),
            child: Text('${pageDate.year}年${pageDate.month}月', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          ),
        ),
      );
    };
    _headBuilder = widget.headBuilder ?? (context, week, state, _) {
      return Container(
        alignment: Alignment.center,
        child: Text(week, style: const TextStyle(color: Color(0xff000000)),),
      );
    };
    _tileBuilder = widget.tileBuilder ?? (context, date, state, animValue) {
      var color, bgColor;
      switch(state) {
        case TileState.selected:
          color = const Color(0xffffffff);
          bgColor = const Color(0xff2376b7);
          break;
        case TileState.active:
          color = const Color(0xff333333);
          bgColor = const Color(0xffffffff);
          break;
        case TileState.inactive:
          color = const Color(0xffaaaaaa);
          bgColor = const Color(0xffffffff);
      }
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Text(date.day.toString(), style: TextStyle(color: color),),
        ),
      );
    };

    if (widget.onInitiate != null) {
      widget.onInitiate(_selectedDate);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            key: const ValueKey('flex_calendar_title_box'),
            child: _titleBuilder(context, _selectedDate, _pageDate, _animValue),
          ),
          Expanded(
            flex: 1,
            child: Container(
              key: const ValueKey('flex_calendar_head_line_box'),
              child: _buildHeadRow(widget.weekLabels),
            ),
          ),
          Expanded(
            flex: 6,
            child: PageView.builder(
              key: const ValueKey('flex_calendar_page_view'),
              itemBuilder: (context, position) {
                final page = position - pageHugeOffset;
                final animValue = (position - _currentPageValue).clamp(-1.0, 1.0);
                if (position == _currentPageValue.floor()) {
                  return Transform(
                    transform: Matrix4.identity()..scale(1 + animValue / 8),
                    alignment: Alignment.centerRight,
                    child: Opacity(
                      opacity: 1 + animValue,
                      child: _buildMonthPage(_initYear, _initMonth + page, 1 + animValue),
                    ),
                  );
                } else if (position == _currentPageValue.floor() + 1) {
                  return Transform(
                    transform: Matrix4.identity()..scale(1 - animValue / 8),
                    alignment: Alignment.centerLeft,
                    child: Opacity(
                      opacity: 1 - animValue,
                      child: _buildMonthPage(_initYear, _initMonth + page, 1 - animValue),
                    ),
                  );
                } else {
                  return _buildMonthPage(_initYear, _initMonth + page, 1);
                }
              },
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _pageDate = DateTime(_initYear, _initMonth + page - pageHugeOffset);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadRow(List<String> labels) {
    assert(labels.length == DateTime.daysPerWeek);
    final list = [_headBuilder(context, labels[DateTime.daysPerWeek - 1], _selectedDate.weekday == DateTime.sunday ? TileState.selected : TileState.active, _animValue)];
    for (var i = 0; i < DateTime.saturday; i++) {
      list.add(_headBuilder(context, labels[i], _selectedDate.weekday == i + 1 ? TileState.selected : TileState.active, _animValue));
    }
    assert(list.length == DateTime.daysPerWeek);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: list.map((item) => Expanded(child: item,)).toList(),
    );
  }

  Widget _buildRow(List<Widget> items) {
    assert(items.length == DateTime.daysPerWeek);
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) => Expanded(child: item,)).toList(),
      ),
    );
  }

  Widget _buildMonthPage(int year, int month, double animValue) {
    final baseDate = DateTime(year, month, 1);
    final baseWeekDay = baseDate.weekday;
    final blockList = <Widget>[];

    var floatDate = baseDate;
    // 如果本月第一天不是周日，向前填充至上一个周日.
    if (baseWeekDay != DateTime.sunday) {
      for(var i = baseWeekDay; i >= 1; i--) {
        final tile = _tileBuilder(context, baseDate.subtract(Duration(days: i)), TileState.inactive, animValue);
        blockList.add(tile);
      }
    }
    // 构建本月的日期
    while(floatDate.month == baseDate.month) {
      final state = (floatDate.year == _selectedDate.year
          && floatDate.month == _selectedDate.month
          && floatDate.day == _selectedDate.day) ? TileState.selected : TileState.active;
      final tappedDate = floatDate;
      final tile = GestureDetector(
        child: _tileBuilder(context, floatDate, state, animValue),
        onTap: () {
          setState(() {
            _selectedDate = tappedDate;
          });
          _controller.value = _selectedDate;
        },
      );
      blockList.add(tile);
      floatDate = floatDate.add(Duration(days: 1));
    }
    // 填充下月日期至满6行
    final sixLinesCount = 6 * DateTime.daysPerWeek;
    while(blockList.length < sixLinesCount) {
      final tile = _tileBuilder(context, floatDate, TileState.inactive, animValue);
      blockList.add(tile);
      floatDate = floatDate.add(Duration(days: 1));
    }
    assert(blockList.length == sixLinesCount);

    List<Widget> rows = [];
    for (var i = 0; i < 6; i++) { // 行循环
      final lineStart = i * DateTime.daysPerWeek;
      final lineEnd = (i + 1) * DateTime.daysPerWeek - 1;
      final List<Widget> row = [];
      for (var j = lineStart; j <= lineEnd; j++) { // 列循环
        row.add(blockList[j]);
      }
      rows.add(_buildRow(row));
    }

    return Column(
      key: ValueKey('flex_calendar_month_page_$baseDate'),
      children: rows,
    );
  }
}