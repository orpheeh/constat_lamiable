import 'dart:async';

import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

class FormConducteur extends StatefulWidget {
  final FormRepository formRepository;

  final double paddingBottom;

  final StreamSink flowSink;

  const FormConducteur(
      {Key key, @required this.formRepository, @required this.flowSink, this.paddingBottom = 64.0})
      : super(key: key);

  @override
  _FormConducteurState createState() => _FormConducteurState();
}

class _FormConducteurState extends State<FormConducteur> {
  DateTime _selectedDate = DateTime.now();
  bool delIsSelected = false;
  bool valIsSelected = false;

  TextEditingController _nomController = new TextEditingController();
  TextEditingController _prenomController = new TextEditingController();
  TextEditingController _adresseController = new TextEditingController();
  TextEditingController _cycloController = new TextEditingController();
  TextEditingController _telController = new TextEditingController();
  TextEditingController _permisController = new TextEditingController();
  TextEditingController _delParController = new TextEditingController();

  bool canNext() {
    return widget.formRepository.conducteur.nom.isNotEmpty &&
        widget.formRepository.conducteur.prenom.isNotEmpty &&
        widget.formRepository.conducteur.adresse.isNotEmpty &&
        widget.formRepository.conducteur.telephone.isNotEmpty &&
        widget.formRepository.conducteur.licenceCyclomoteur.isNotEmpty &&
        widget.formRepository.conducteur.numeroPermisConduire.isNotEmpty &&
        widget.formRepository.conducteur.category != "Catégorie" &&
        widget.formRepository.conducteur.delivrer != null &&
        widget.formRepository.conducteur.delivrerPar.isNotEmpty &&
        widget.formRepository.conducteur.dateValidite != null;
  }

  Future<Null> _selectDate(BuildContext context, String str) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1960, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        if (str == "del") {
          widget.formRepository.conducteur.delivrer = _selectedDate;
          delIsSelected = true;
        } else {
          widget.formRepository.conducteur.dateValidite = _selectedDate;
          valIsSelected = true;
        }
        widget.flowSink.add(canNext());
      });
  }

  @override
  void initState() {
    super.initState();

    delIsSelected = widget.formRepository.conducteur.delivrer != null;
    valIsSelected = widget.formRepository.conducteur.dateValidite != null;

    _nomController.text = widget.formRepository.conducteur.nom;
    _prenomController.text = widget.formRepository.conducteur.prenom;
    _adresseController.text = widget.formRepository.conducteur.adresse;
    _telController.text = widget.formRepository.conducteur.telephone;
    _cycloController.text = widget.formRepository.conducteur.licenceCyclomoteur;
    _permisController.text =
        widget.formRepository.conducteur.numeroPermisConduire;
    _delParController.text = widget.formRepository.conducteur.delivrerPar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: widget.paddingBottom),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Munissez vous du permis de conduire du conducteur",
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (text) {
                        widget.formRepository.conducteur.nom = text;
                        widget.flowSink.add(canNext());
                      },
                      controller: _nomController,
                      decoration: InputDecoration(
                          labelText: "Nom",
                          contentPadding: EdgeInsets.all(14.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (text) {
                        widget.formRepository.conducteur.prenom = text;
                        widget.flowSink.add(canNext());
                      },
                      controller: _prenomController,
                      decoration: InputDecoration(
                          labelText: "Prénom",
                          contentPadding: EdgeInsets.all(14.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                widget.formRepository.conducteur.adresse = text;
                widget.flowSink.add(canNext());
              },
              controller: _adresseController,
              decoration: InputDecoration(
                  labelText: "Adresse",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                widget.formRepository.conducteur.telephone = text;
                widget.flowSink.add(canNext());
              },
              controller: _telController,
              decoration: InputDecoration(
                  labelText: "Téléphone",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                widget.formRepository.conducteur.licenceCyclomoteur = text;
                widget.flowSink.add(canNext());
              },
              controller: _cycloController,
              decoration: InputDecoration(
                  labelText: "Licence cyclomoteur",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                widget.formRepository.conducteur.numeroPermisConduire = text;
                widget.flowSink.add(canNext());
              },
              controller: _permisController,
              decoration: InputDecoration(
                  labelText: "Permis de conduire n°",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: widget.formRepository.conducteur.category,
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  widget.formRepository.conducteur.category = newValue;
                  widget.flowSink.add(canNext());
                });
              },
              items: <String>["Catégorie", 'A1', 'A' 'B', 'C', 'D', 'E', 'F']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.perm_identity),
                        Text(value)
                      ],
                    ));
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Délivré le : "),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                _selectDate(context, "del");
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.calendar_today),
                  Text(delIsSelected
                      ? "${widget.formRepository.conducteur.delivrer.toIso8601String().split('T')[0]}"
                      : "choisir une date")
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                widget.formRepository.conducteur.delivrerPar = text;
                widget.flowSink.add(canNext());
              },
              controller: _delParController,
              decoration: InputDecoration(
                  labelText: "Délivré par",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Permis valable jusqu'au"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                _selectDate(context, "val");
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.calendar_today),
                  Text(valIsSelected
                      ? "${widget.formRepository.conducteur.dateValidite.toIso8601String().split('T')[0]}"
                      : "choisir une date")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
