import 'dart:async';

import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

import 'drawing_table.dart';

class FormSignature extends StatefulWidget {
  final String numero;
  final FormRepository formRepository;
  final StreamSink sink;
  final String vehicule;

  const FormSignature(
      {Key key,
      @required this.vehicule,
      @required this.numero,
      @required this.formRepository,
      @required this.sink})
      : super(key: key);
  @override
  _FormSignatureState createState() => _FormSignatureState();
}

class _FormSignatureState extends State<FormSignature> {
  bool repaint = false;

  _onDragStart(DragStartDetails details) {
    setState(() {
      repaint = true;
      widget.formRepository.points
          .add(Point(x: details.localPosition.dx, y: details.localPosition.dy));
    });
  }

  _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      repaint = true;
      widget.formRepository.points
          .add(Point(x: details.localPosition.dx, y: details.localPosition.dy));
    });
  }

  _onDragEnd(DragEndDetails details) {
    setState(() {
      widget.formRepository.points.add(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 64.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
          Widget>[
        Row(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.all(16.0),
              icon: Icon(Icons.clear_all),
              onPressed: () {
                setState(() {
                  widget.formRepository.points.clear();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${widget.formRepository.pictureCount}",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            Icon(
              Icons.image,
              color: Colors.grey,
            ),
            Expanded(
              child: Container(),
            ),
            widget.formRepository.isOffline
                ? Container()
                : IconButton(
                    onPressed: () {
                      widget.sink.add({
                        "type": 0,
                        "numero": widget.numero,
                        "vehicule": widget.vehicule
                      });
                    },
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.blue,
                    ),
                  )
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
                    points: widget.formRepository.points, repaint: repaint),
                child: Center(
                  child: Text(
                    "APPOSEZ VOTRE SIGNATURE ICI".toUpperCase(),
                    style: TextStyle(color: Color.fromARGB(100, 128, 128, 128)),
                  ),
                ),
              ),
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            widget.sink
                .add({"numero": widget.numero, "vehicule": widget.vehicule});
          },
          child: Text("Terminer"),
        )
      ]),
    );
  }
}
