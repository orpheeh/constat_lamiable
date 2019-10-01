import 'dart:async';

import 'package:constat_lamiable/common/degat_indicator.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

class FormDegat extends StatefulWidget {
  final FormRepository formRepository;
  final StreamSink flowSink;

  const FormDegat(
      {Key key, @required this.formRepository, @required this.flowSink})
      : super(key: key);
  @override
  _FormDegatState createState() => _FormDegatState();
}

class _FormDegatState extends State<FormDegat> {
  bool showCroquis = false;

  TextEditingController _degAppController = new TextEditingController();
  TextEditingController _obsController = new TextEditingController();

  bool canNext() {
    return widget.formRepository.degat.chocInitial != ChocInitial.NONE;
  }

  @override
  void initState() {
    super.initState();
    _degAppController.text = widget.formRepository.degat.degatApparents;
    _obsController.text = widget.formRepository.degat.observations;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 64.0,
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Indiquez sur le croquis le point de choc initial",
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        showCroquis = !showCroquis;
                      });
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(showCroquis
                            ? Icons.visibility
                            : Icons.visibility_off),
                        Text(showCroquis
                            ? "Cacher le croquis"
                            : "Afficher le croquis")
                      ],
                    ),
                  ),
                  showCroquis
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DegatIndicator(
                            formRepository: widget.formRepository,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (value) {
                    setState(() {
                      widget.formRepository.degat.blesser = value;
                    });
                  },
                  value: widget.formRepository.degat.blesser,
                ),
                Expanded(
                    child: Text(
                        "Cochez cette case si il y'a eu des bléssés, même légers ?"))
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (value) {
                    setState(() {
                      widget.formRepository.degat.degatMateriel = value;
                    });
                  },
                  value: widget.formRepository.degat.degatMateriel,
                ),
                Expanded(
                    child: Text(
                        "Cochez cette case si il y'a eu des dégâts matériels autres qu'aux véhicules A et B?"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (text) {
                  widget.formRepository.degat.degatApparents = text;
                },
                controller: _degAppController,
                decoration: InputDecoration(
                    labelText: "Dégats apparents",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                maxLines: 2,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (text) {
                  widget.formRepository.degat.observations = text;
                },
                controller: _obsController,
                decoration: InputDecoration(
                    labelText: "Observations",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                maxLines: 2,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
