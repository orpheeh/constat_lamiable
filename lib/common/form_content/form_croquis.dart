import 'package:constat_lamiable/common/form_content/drawing_table.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

class FormCroquis extends StatefulWidget {
  final FormRepository formRepository;

  const FormCroquis({Key key, @required this.formRepository}) : super(key: key);

  @override
  _FormCroquisState createState() => _FormCroquisState();
}

enum Tool { PENCIL, RUBBER }

class _FormCroquisState extends State<FormCroquis> {
  bool repaint = false;
  Tool drawTool = Tool.PENCIL;
  final int rubberRadius = 20;

  _onDragStart(DragStartDetails details) {
    setState(() {
      repaint = true;
      if (drawTool == Tool.PENCIL) {
        widget.formRepository.croquis.points.add(
            Point(x: details.localPosition.dx, y: details.localPosition.dy));
      }
    });
  }

  _onDragUpdate(DragUpdateDetails details) {
    repaint = true;
    if (drawTool == Tool.PENCIL) {
      widget.formRepository.croquis.points
          .add(Point(x: details.localPosition.dx, y: details.localPosition.dy));
    }

    if (drawTool == Tool.RUBBER) {
      _removePoint(details.localPosition.dx, details.localPosition.dy);
    }
  }

  _onDragEnd(DragEndDetails details) {
    setState(() {
      if (drawTool == Tool.PENCIL) {
        widget.formRepository.croquis.points.add(null);
      }
    });
  }

  void _removePoint(double dx, double dy) {
    for (int i = 0; i < widget.formRepository.croquis.points.length; i++) {
      if (widget.formRepository.croquis.points[i] == null) {
        continue;
      }

      double x = widget.formRepository.croquis.points[i].x;
      double y = widget.formRepository.croquis.points[i].y;

      if ((x - dx) * (x - dx) + (y - dy) * (y - dy) <
          rubberRadius * rubberRadius) {
        widget.formRepository.croquis.points[i] = null;
        if (i + 1 < widget.formRepository.croquis.points.length &&
            widget.formRepository.croquis.points[i + 1] == null) {
          widget.formRepository.croquis.points.removeAt(i + 1);
        }
        if (i - 1 < widget.formRepository.croquis.points.length &&
            i - 1 >= 0 &&
            widget.formRepository.croquis.points[i - 1] == null) {
          widget.formRepository.croquis.points.removeAt(i - 1);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 64.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(16.0),
                color: drawTool == Tool.PENCIL ? Colors.blue : Colors.grey,
                icon: Icon(Icons.brush),
                onPressed: () {
                  setState(() {
                    drawTool = Tool.PENCIL;
                  });
                },
              ),
              IconButton(
                padding: EdgeInsets.all(16.0),
                color: drawTool == Tool.RUBBER ? Colors.blue : Colors.grey,
                icon: Icon(Icons.crop_portrait),
                onPressed: () {
                  setState(() {
                    drawTool = Tool.RUBBER;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onPanStart: _onDragStart,
              onPanUpdate: _onDragUpdate,
              onPanEnd: _onDragEnd,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey)),
                child: CustomPaint(
                  painter: DrawingTable(
                      points: widget.formRepository.croquis.points,
                      repaint: repaint),
                  child: Center(
                    child: Text(
                      "Dessinez le croquis de l'accident ici".toUpperCase(),
                      style:
                          TextStyle(color: Color.fromARGB(100, 128, 128, 128)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
