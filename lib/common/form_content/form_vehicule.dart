import 'dart:async';

import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

class FormVehicule extends StatefulWidget {
  final FormRepository formRepository;
  final StreamSink flowSink;

  const FormVehicule(
      {Key key, @required this.formRepository, @required this.flowSink})
      : super(key: key);
  @override
  _FormVehiculeState createState() => _FormVehiculeState();
}

class _FormVehiculeState extends State<FormVehicule> {
  TextEditingController _immatriculation = new TextEditingController();
  TextEditingController _moteur = new TextEditingController();

  bool canNext() {
    return widget.formRepository.currentCarIndex >= 0 &&
        widget.formRepository.numeroImmatriculation != null &&
        widget.formRepository.numeroMoteur != null &&
        widget.formRepository.numeroImmatriculation.isNotEmpty &&
        widget.formRepository.numeroMoteur.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _immatriculation.text = widget.formRepository.numeroImmatriculation;
    _moteur.text = widget.formRepository.numeroMoteur;

    return Container(
        decoration: BoxDecoration(color: Colors.transparent),
        margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 64.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Tapez sur le type de véhicule que vous aviez",
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
                children: List.generate(widget.formRepository.carTypes.length,
                    (index) {
              return Container(
                child: Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.formRepository.currentCarIndex = index;
                      widget.flowSink.add(canNext());
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: index == widget.formRepository.currentCarIndex
                            ? Colors.green
                            : Colors.transparent),
                    margin: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      widget.formRepository.carTypes[index].asset,
                      height: 150,
                    ),
                  ),
                )),
              );
            })),
            widget.formRepository.currentCarIndex >= 0
                ? ListTile(
                    leading: Checkbox(
                      onChanged: (value) {
                        setState(() {
                          widget
                              .formRepository
                              .carTypes[widget.formRepository.currentCarIndex]
                              .useRemorque = value;
                        });
                      },
                      value: widget
                          .formRepository
                          .carTypes[widget.formRepository.currentCarIndex]
                          .useRemorque,
                    ),
                    title: Text("J'utilise une remorque ou une semi remorque"))
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  widget.formRepository.numeroImmatriculation = value;
                  widget.flowSink.add(canNext());
                },
                controller: _immatriculation,
                decoration: InputDecoration(
                    labelText: "N° d'immatriculation",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    contentPadding: EdgeInsets.all(14.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  widget.formRepository.numeroMoteur = value;
                  widget.flowSink.add(canNext());
                },
                controller: _moteur,
                decoration: InputDecoration(
                    labelText: "N° du moteur",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    contentPadding: EdgeInsets.all(14.0)),
              ),
            ),
          ],
        ));
  }
}
