import 'dart:async';

import 'package:constat_lamiable/common/form_content/form_assurance.dart';
import 'package:constat_lamiable/common/form_content/form_conducteur.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final FormRepository formRepository;
  final Repository repository;

  const ProfilePage(
      {Key key, @required this.formRepository, @required this.repository})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 0;
  String _numero;

  Future<String> numeroPdf;

  StreamController assuranceStreamController = new StreamController();
  StreamController permisStreamController = new StreamController();

  List<Widget> getPages({String numero, String pdfURL}) => [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: FormAssurance(
                      formRepository: widget.formRepository,
                      flowSink: assuranceStreamController.sink,
                      paddingBottom: 16.0)),
              RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    //Persist assurance
                    widget.formRepository.assurance.persist();
                    Fluttertoast.showToast(
                        msg: "Nouvelles informations enregistré !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 3,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 14.0);
                  },
                  child: Text("Enregistrer"))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: FormConducteur(
                      formRepository: widget.formRepository,
                      flowSink: permisStreamController.sink,
                      paddingBottom: 16.0)),
              RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    //Persist permis
                    widget.formRepository.conducteur.persist();
                    Fluttertoast.showToast(
                        msg: "Nouvelle informations enregistré !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 3,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 14.0);
                  },
                  child: Text("Enregistrer"))
            ],
          ),
        ),
        numero == ""
            ? Text("Aucun constat")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Numéro du dernier constat"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child:
                        Text("$numero", style: TextStyle(color: Colors.grey)),
                  ),
                  RaisedButton(
                      onPressed: pdfURL == "" || pdfURL == null
                          ? null
                          : () async {
                              _launchURL(pdfURL);
                            },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Télécharger le PDF")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Vous ne pouvez pas télécharger le PDF car l'autre partie du formulaire n'a pas encore été remplis !",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 10.0, color: Colors.grey[700])),
                  )
                ],
              )
      ];

  @override
  void dispose() {
    super.dispose();
    assuranceStreamController.close();
    permisStreamController.close();
  }

  @override
  void initState() {
    super.initState();
    loadNumeroCompteur();
    numeroPdf = widget.repository.getPDF();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void loadNumeroCompteur() async {
    _numero = await FormRepository.getNumeroConstat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes informations personnelles")),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_late), title: Text("Assurance")),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car), title: Text("Permis")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin), title: Text("Dernier constat")),
          ],
          currentIndex: _currentIndex,
          onTap: (int i) {
            setState(() {
              _currentIndex = i;
            });
          }),
      body: Center(
        child: FutureBuilder(
          future: numeroPdf,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return getPages(
                  numero: _numero, pdfURL: snapshot.data)[_currentIndex];
            }
            if (snapshot.hasError) {
              return getPages(
                  numero: _numero, pdfURL: snapshot.data)[_currentIndex];
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
