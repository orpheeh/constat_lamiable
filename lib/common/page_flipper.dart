import 'dart:ui';

import 'package:flutter/material.dart';

class PageFlipper extends StatefulWidget {
  final List<Widget> pages;

  final List<String> titles;

  double moveStart;

  double moveEnd;

  double scrollPercent = 0.0;

  AnimationController animationController;

  PageFlipper({@required this.pages, @required this.titles});

  int next() {
    if (scrollPercent - scrollPercent.toInt().toDouble() > 0.0) {
      return scrollPercent.toInt();
    }
    moveStart = scrollPercent;
    moveEnd = scrollPercent + 1;

    if (!(scrollPercent.toInt() + 1 > pages.length - 1)) {
      animationController.forward(from: 0.0);
    }
    return scrollPercent.toInt() + 1;
  }

  int back() {
    if (scrollPercent - scrollPercent.toInt().toDouble() > 0.0) {
      return scrollPercent.toInt();
    }
    moveStart = scrollPercent;
    moveEnd = scrollPercent - 1;
    if (moveStart < 1.0) {
      return scrollPercent.toInt();
    }
    animationController.forward(from: 0.0);
    return scrollPercent.toInt() + 1;
  }

  @override
  _PageFlipperState createState() => _PageFlipperState();
}

class _PageFlipperState extends State<PageFlipper>
    with TickerProviderStateMixin {
  Widget _page(int pageIndex) {
    return FractionalTranslation(
      translation: Offset(pageIndex - widget.scrollPercent, 0.0),
      child: Container(width: double.infinity, child: widget.pages[pageIndex]),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.animationController = new AnimationController(
        duration: Duration(milliseconds: 500), vsync: this)
      ..addListener(() {
        setState(() {
          widget.scrollPercent = lerpDouble(widget.moveStart, widget.moveEnd,
              widget.animationController.value);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.moveStart = 0.0;
          widget.moveEnd = 0.0;
        }
      });
  }

  @override
  void dispose() {
    super.dispose();

    widget.animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: PageFlipperPoint(
            scrollPercent: widget.scrollPercent,
            pointCount: widget.pages.length,
            color: Colors.grey,
            focusColor: Colors.blue,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.titles[widget.scrollPercent.toInt()],
            style: TextStyle(
                color: Colors.blue,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          child: Stack(
              alignment: Alignment.center,
              children:
                  List.generate(widget.pages.length, (index) => _page(index))),
        ),
      ],
    );
  }
}

class PageFlipperPoint extends StatelessWidget {
  final double scrollPercent;
  final int pointCount;
  final Color color;
  final Color focusColor;

  const PageFlipperPoint(
      {Key key,
      this.scrollPercent,
      @required this.pointCount,
      @required this.color,
      @required this.focusColor})
      : super(key: key);

  Widget _point(Color color, {double size = 4, bool current = false}) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: size,
      height: current == false ? size : size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = scrollPercent.toInt();
    return Stack(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pointCount, (index) {
              if (index < currentIndex) {
                return _point(Colors.blue[700]);
              }
              return _point(Colors.grey[300]);
            })),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                pointCount,
                (index) => index == pointCount - 1
                    ? FractionalTranslation(
                        translation:
                            Offset(scrollPercent - pointCount + 1, 0.0),
                        child: _point(focusColor, size: 4, current: true))
                    : _point(Colors.transparent, size: 4))),
      ],
    );
  }
}
