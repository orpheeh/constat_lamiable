import 'dart:async';

import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

class FormAssurance extends StatefulWidget {
  final FormRepository formRepository;

  final StreamSink flowSink;

  const FormAssurance(
      {Key key, @required this.flowSink, @required this.formRepository})
      : super(key: key);

  @override
  _FormAssuranceState createState() => _FormAssuranceState();
}

class _FormAssuranceState extends State<FormAssurance> {
  DateTime _selectedDate;

  TextEditingController _nomController = new TextEditingController();
  TextEditingController _prenomController = new TextEditingController();
  TextEditingController _adresseController = new TextEditingController();
  TextEditingController _bpController = new TextEditingController();
  TextEditingController _telController = new TextEditingController();
  TextEditingController _policeController = new TextEditingController();
  TextEditingController _crController = new TextEditingController();
  TextEditingController _courtierController = new TextEditingController();

  bool canNext() {
    return widget.formRepository.assurance.nom.isNotEmpty &&
        widget.formRepository.assurance.prenom.isNotEmpty &&
        widget.formRepository.assurance.adresse.isNotEmpty &&
        widget.formRepository.assurance.bp.isNotEmpty &&
        widget.formRepository.assurance.tel.isNotEmpty &&
        widget.formRepository.assurance.valableDu != null &&
        widget.formRepository.assurance.valableAu != null &&
        widget.formRepository.assurance.numeroPolice.isNotEmpty &&
        widget.formRepository.assurance.numeroCarteRose.isNotEmpty &&
        widget.formRepository.assurance.steAssurance != "Société d'assurance";
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
        if (str == "du") {
          widget.formRepository.assurance.valableDu = _selectedDate;
        } else {
          widget.formRepository.assurance.valableAu = _selectedDate;
        }
        widget.flowSink.add(canNext());
      });
  }

  @override
  void initState() {
    super.initState();
    _nomController.text = widget.formRepository.assurance.nom;
    _prenomController.text = widget.formRepository.assurance.prenom;
    _adresseController.text = widget.formRepository.assurance.adresse;
    _bpController.text = widget.formRepository.assurance.bp;
    _telController.text = widget.formRepository.assurance.tel;
    _policeController.text = widget.formRepository.assurance.numeroPolice;
    _crController.text = widget.formRepository.assurance.numeroCarteRose;
    _courtierController.text = widget.formRepository.assurance.agenceCourtier;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 64.0),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Munissez vous de votre attestation d'assurance",
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
                        widget.formRepository.assurance.nom = text;
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
                        widget.formRepository.assurance.prenom = text;
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
                widget.formRepository.assurance.adresse = text;
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
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (text) {
                      widget.formRepository.assurance.bp = text;
                      widget.flowSink.add(canNext());
                    },
                    controller: _bpController,
                    decoration: InputDecoration(
                        labelText: "B.P",
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
                      widget.formRepository.assurance.tel = text;
                      widget.flowSink.add(canNext());
                    },
                    controller: _telController,
                    decoration: InputDecoration(
                        labelText: "Tel",
                        contentPadding: EdgeInsets.all(14.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: widget.formRepository.assurance.steAssurance,
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  widget.formRepository.assurance.steAssurance = newValue;
                  widget.flowSink.add(canNext());
                });
              },
              items: <String>["Société d'assurance", 'Ogar', 'Axa', 'Nsia']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: <Widget>[Icon(Icons.favorite), Text(value)],
                    ));
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                widget.formRepository.assurance.numeroPolice = text;
                widget.flowSink.add(canNext());
              },
              controller: _policeController,
              decoration: InputDecoration(
                  labelText: "N° de police",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                widget.formRepository.assurance.numeroCarteRose = text;
                widget.flowSink.add(canNext());
              },
              controller: _crController,
              decoration: InputDecoration(
                  labelText: "N° de carte rose",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Text("Attestation valable"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                _selectDate(context, "du");
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.calendar_today),
                  Text(
                    widget.formRepository.assurance.valableDu == null
                        ? "du (choisir la date)"
                        : "du ${widget.formRepository.assurance.valableDu.toString().split(' ')[0]}",
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                _selectDate(context, "au");
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.calendar_today),
                  Text(widget.formRepository.assurance.valableAu == null
                      ? "au (choisir la date)"
                      : "au ${widget.formRepository.assurance.valableAu.toString().split(' ')[0]}")
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                widget.formRepository.assurance.agenceCourtier = text;
                widget.flowSink.add(canNext());
              },
              controller: _courtierController,
              decoration: InputDecoration(
                  labelText: "Agence, courtier",
                  contentPadding: EdgeInsets.all(14.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
        ],
      ),
    );
  }
}
