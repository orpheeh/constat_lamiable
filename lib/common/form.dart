import 'dart:async';

import 'package:constat_lamiable/common/form_content/form_assurance.dart';
import 'package:constat_lamiable/common/form_content/form_circonstance.dart';
import 'package:constat_lamiable/common/form_content/form_conducteur.dart';
import 'package:constat_lamiable/common/form_content/form_context.dart';
import 'package:constat_lamiable/common/form_content/form_croquis.dart';
import 'package:constat_lamiable/common/form_content/form_degat.dart';
import 'package:constat_lamiable/common/form_content/form_recap.dart';
import 'package:constat_lamiable/common/form_content/form_signature.dart';
import 'package:constat_lamiable/common/form_content/form_vehicule.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/page_flipper.dart';
import 'package:flutter/material.dart';

class ConstatForm extends StatefulWidget {
  final FormRepository formRepository;
  final String numero;
  final String vehicule;
  final StreamSink sink;
  final double scrollPercentInitial;

  const ConstatForm(
      {Key key,
      @required this.formRepository,
      @required this.sink,
      @required this.numero,
      @required this.vehicule,
      this.scrollPercentInitial = 0.0})
      : super(key: key);
  @override
  _ConstatFormState createState() => _ConstatFormState();
}

class _ConstatFormState extends State<ConstatForm> {
  PageFlipper _pageFlipper;

  final StreamController flowStreamController = new StreamController();

  @override
  void initState() {
    super.initState();

    flowStreamController.stream.listen((data) {
      setState(() {
      });
    });

    _pageFlipper = PageFlipper(
      titles: <String>[
        "Contexte",
        "Véhicule",
        "Assurance",
        "Conducteur",
        "Dégât",
        "Circonstance",
        "Croquis",
        "Récapitulatif",
        "Signature"
      ],
      pages: <Widget>[
        FormContexte(
          formRepository: widget.formRepository,
          flowSink: flowStreamController.sink,
        ),
        FormVehicule(
          formRepository: widget.formRepository,
          flowSink: flowStreamController.sink,
        ),
        FormAssurance(
          formRepository: widget.formRepository,
          flowSink: flowStreamController.sink,
        ),
        FormConducteur(
          formRepository: widget.formRepository,
          flowSink: flowStreamController.sink,
        ),
        FormDegat(
          formRepository: widget.formRepository,
          flowSink: flowStreamController.sink,
        ),
        FormCirconstance(
          formRepository: widget.formRepository,
        ),
        FormCroquis(
          formRepository: widget.formRepository,
        ),
        FormRecap(formRepository: widget.formRepository),
        FormSignature(
            formRepository: widget.formRepository,
            numero: widget.numero,
            sink: widget.sink,
            vehicule: widget.vehicule)
      ],
    );
    _pageFlipper.scrollPercent = widget.scrollPercentInitial;
  }

  @override
  void dispose() {
    super.dispose();
    flowStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          _pageFlipper,
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _pageFlipper.back();
                          });
                        },
                        child: Text("Précédent"),
                        color: Colors.blue,
                        textColor: Colors.white,
                      ),
                      Expanded(child: Container()),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _pageFlipper.next();
                          });
                        },
                        child: Text("Suivant"),
                        color: Colors.blue,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
