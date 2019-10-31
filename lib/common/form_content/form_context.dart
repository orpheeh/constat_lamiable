import 'dart:async';

import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class FormContexte extends StatefulWidget {
  final FormRepository formRepository;
  final StreamSink flowSink;

  const FormContexte({Key key, this.formRepository, @required this.flowSink})
      : super(key: key);
  @override
  _FormContexteState createState() => _FormContexteState();
}

class _FormContexteState extends State<FormContexte> {
  bool isClicked = false;

  bool _showAddTemoinForm = false;
  TextEditingController _lieuPrecisController = new TextEditingController();
  TextEditingController _villeController = new TextEditingController();
  TextEditingController _venantController = new TextEditingController();
  TextEditingController _allantController = new TextEditingController();

  TextEditingController _temoinNomController = new TextEditingController();
  TextEditingController _temoinPrenomController = new TextEditingController();
  TextEditingController _temoinTelController = new TextEditingController();
  TextEditingController _temoinEmailController = new TextEditingController();

  bool _isSelectedDate = false;
  bool _isSelectedTime = false;
  bool _showCart = true;
  final months = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juiller',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];

  bool _canNext() {
    return widget.formRepository.context.date != null &&
        widget.formRepository.context.time != null &&
        widget.formRepository.context.lieuPrecis.isNotEmpty &&
        widget.formRepository.context.ville.isNotEmpty &&
        widget.formRepository.context.venantDe.isNotEmpty &&
        widget.formRepository.context.allantVers.isNotEmpty;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1960, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.formRepository.context.date)
      setState(() {
        widget.formRepository.context.date = picked;
        _isSelectedDate = true;
        widget.flowSink.add(_canNext());
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != widget.formRepository.context.time)
      setState(() {
        widget.formRepository.context.time = picked;
        _isSelectedTime = true;
        widget.flowSink.add(_canNext());
      });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _showCart = !widget.formRepository.isOffline;

    _isSelectedDate = widget.formRepository.context.date != null;
    _isSelectedTime = widget.formRepository.context.time != null;

    _lieuPrecisController.text = widget.formRepository.context.lieuPrecis;
    _villeController.text = widget.formRepository.context.ville;
    _venantController.text = widget.formRepository.context.venantDe;
    _allantController.text = widget.formRepository.context.allantVers;
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 64.0),
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: (text) {
                    widget.formRepository.context.lieuPrecis = text;
                    widget.flowSink.add(_canNext());
                  },
                  controller: _lieuPrecisController,
                  decoration: InputDecoration(
                      labelText: "Lieu précis",
                      prefixIcon: Icon(Icons.location_searching),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      contentPadding: EdgeInsets.all(14.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                child: TextField(
                  onChanged: (text) {
                    widget.formRepository.context.ville = text;
                    widget.flowSink.add(_canNext());
                  },
                  controller: _villeController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      labelText: "Ville",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      contentPadding: EdgeInsets.all(14.0)),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 0.0, top: 0.0, bottom: 16.0),
                      child: TextField(
                        onChanged: (text) {
                          widget.formRepository.context.venantDe = text;
                          widget.flowSink.add(_canNext());
                        },
                        controller: _venantController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.directions_car),
                            labelText: "Venant de",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            contentPadding: EdgeInsets.all(14.0)),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_right),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 16.0, top: 0.0, bottom: 16.0),
                      child: TextField(
                        onChanged: (text) {
                          widget.formRepository.context.allantVers = text;
                          widget.flowSink.add(_canNext());
                        },
                        controller: _allantController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.directions_car),
                            labelText: "Allant vers",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            contentPadding: EdgeInsets.all(14.0)),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                child: Text(
                  "Liste des témoins",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      _showAddTemoinForm = !_showAddTemoinForm;
                    });
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: _showAddTemoinForm
                      ? Text("Voir la liste des témoins")
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.person_add),
                            Text("Ajouter un temoin"),
                          ],
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _showAddTemoinForm
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    decoration:
                                        InputDecoration(labelText: "Nom"),
                                    controller: _temoinNomController,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    decoration:
                                        InputDecoration(labelText: "Prénom"),
                                    controller: _temoinPrenomController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              decoration:
                                  InputDecoration(labelText: "Téléphone"),
                              controller: _temoinTelController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              decoration:
                                  InputDecoration(labelText: "Adresse Email"),
                              controller: _temoinEmailController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RaisedButton(
                              onPressed: () {
                                //Add temoin
                                Temoin temoin = Temoin(
                                    nom: _temoinNomController.text,
                                    prenom: _temoinPrenomController.text,
                                    tel: _temoinTelController.text,
                                    email: _temoinEmailController.text);
                                widget.formRepository.context.temoins
                                    .add(temoin);
                                _temoinNomController.text = "";
                                _temoinPrenomController.text = "";
                                _temoinTelController.text = "";
                                _temoinEmailController.text = "";

                                setState(() {
                                  _showAddTemoinForm = false;
                                });
                              },
                              child: Text("Ajouter"),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: List.generate(
                            widget.formRepository.context.temoins.length,
                            (index) => Container(
                                padding: EdgeInsets.all(16.0),
                                child: ListTile(
                                  title: Text(
                                      "${widget.formRepository.context.temoins[index].nom} ${widget.formRepository.context.temoins[index].prenom}"),
                                  subtitle: Text(
                                      "${widget.formRepository.context.temoins[index].tel}"),
                                  leading: Icon(Icons.person_pin),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        widget.formRepository.context.temoins
                                            .removeAt(index);
                                      });
                                    },
                                  ),
                                ))),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Indiquez la date et l'heure de l'accident",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      _selectDate(context);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Text(_isSelectedDate
                          ? '${widget.formRepository.context.date.day} ${months[widget.formRepository.context.date.month - 1]} ${widget.formRepository.context.date.year}'
                          : "Indiquez la date")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      _selectTime(context);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.timer),
                      Text(_isSelectedTime
                          ? '${widget.formRepository.context.time.hour}:${widget.formRepository.context.time.minute}'
                          : "Indiquez l'heure")
                    ],
                  ),
                ),
              )
            ],
          ),
          !_showCart
              ? Container()
              : Card(
                  elevation: 8.0,
                  color: Colors.pink[100],
                  margin: EdgeInsets.all(16.0),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Indiquez l'endroit ou l'accident a eu lieu sur la carte",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 250,
                      margin: EdgeInsets.all(16.0),
                      child: new FlutterMap(
                        options: new MapOptions(
                            center:
                                widget.formRepository.context.location["lat"] <=
                                        0.0
                                    ? LatLng(0.4115524, 9.294541)
                                    : LatLng(
                                        widget.formRepository.context
                                            .location["lat"],
                                        widget.formRepository.context
                                            .location["lng"]),
                            zoom: 12.0,
                            onTap: (location) {
                              setState(() {
                                widget.formRepository.context.location["lat"] =
                                    location.latitude;
                                widget.formRepository.context.location["lng"] =
                                    location.longitude;
                                isClicked = true;
                              });
                            }),
                        layers: [
                          TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c']),
                          new MarkerLayerOptions(
                            markers: isClicked
                                ? [
                                    new Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: new LatLng(
                                          widget.formRepository.context
                                              .location["lat"],
                                          widget.formRepository.context
                                              .location["lng"]),
                                      builder: (ctx) => GestureDetector(
                                        child: new Container(
                                          child: Icon(
                                            Icons.edit_location,
                                            size: 40.0,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                : [],
                          ),
                        ],
                      ),
                    ),
                    isClicked
                        ? FlatButton(
                            child: Text("Continuer"),
                            color: Colors.purple,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                _showCart = false;
                              });
                            },
                          )
                        : Container()
                  ]),
                )
        ],
      ),
    );
  }
}
