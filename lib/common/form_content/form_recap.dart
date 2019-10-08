import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/recap.dart';
import 'package:flutter/material.dart';

class FormRecap extends StatefulWidget {
  final FormRepository formRepository;

  const FormRecap({Key key, @required this.formRepository}) : super(key: key);
  @override
  _FormRecapState createState() => _FormRecapState();
}

class _FormRecapState extends State<FormRecap> {
  bool _showRecap = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: !_showRecap
              ? RaisedButton(
                  child: Text("Voir le récapitulatif"),
                  onPressed: () {
                    setState(() {
                      
                      _showRecap = true;
                    });
                  },
                )
              : Container(),
        ),
        Expanded(
          child: _showRecap
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 64.0, top: 0.0),
                  child: Recap(
                    formRepository: widget.formRepository,
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
