import 'dart:async';
import 'dart:convert';

import 'package:constat_lamiable/common/form_content/form_assurance.dart';
import 'package:constat_lamiable/common/form_content/form_conducteur.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/offline/local_constat_storage.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final FormRepository formRepository;
  final Repository repository;
  final LocalConstatStorage localConstatStorage;

  const ProfilePage(
      {Key key,
      @required this.formRepository,
      @required this.repository,
      @required this.localConstatStorage})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 0;
  String _numero;
  String _vehicule;
  bool _hasOffline = false;
  bool _canUploadPicture = false;
  int pictureCount = 0;
  LocalConstat saveConstat;

  Future<String> numeroPdf;

  StreamController assuranceStreamController = new StreamController();
  StreamController permisStreamController = new StreamController();

  List<Widget> getPages(
          {String numero, String pdfURL, String vehicule, bool error}) =>
      [
        FormAssurance(
            formRepository: widget.formRepository,
            flowSink: assuranceStreamController.sink,
            paddingBottom: 16.0),
        FormConducteur(
            formRepository: widget.formRepository,
            flowSink: permisStreamController.sink,
            paddingBottom: 16.0),
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
                    child: pdfURL == "" || pdfURL == null
                        ? Text(
                            "Vous ne pouvez pas télécharger le PDF car l'autre partie du formulaire n'a pas encore été remplis !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10.0, color: Colors.grey[700]))
                        : Container(),
                  ),
                  pdfURL == "" || pdfURL == null
                      ? Center(
                          child: QrImage(
                            data: "$numero:$vehicule",
                            version: QrVersions.auto,
                            size: 100.0,
                          ),
                        )
                      : Container(),
                ],
              ),
        _hasOffline
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Envoyer le constat que vous aviez remplis hors ligne",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (saveConstat != null) {
                            final numero =
                                await widget.repository.createConstat();
                            this._numero = numero;
                            await widget.repository.sendForm(
                                vehicule: "A",
                                numero: numero,
                                recap: jsonDecode(saveConstat.a));
                            await widget.repository.sendForm(
                                vehicule: "B",
                                numero: numero,
                                recap: jsonDecode(saveConstat.b));
                            await widget.localConstatStorage
                                .deleteConstat(saveConstat.id);
                            await FormRepository.persistNumeroConstat(numero);
                            setState(() {
                              _hasOffline = false;
                            });
                            _canUploadPicture = true;
                          }
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text("Envoyer"),
                      ),
                    )
                  ])
            : _canUploadPicture
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Envoyez les photos que vous avez prisent de l'accident"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("$pictureCount"),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            takePicture(numero: _numero);
                          },
                        )
                      ])
                : Center(
                    child: Text("Aucune donnée"),
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
    loadOffLine();
    loadNumeroConstat();
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void loadNumeroConstat() async {
    numeroPdf = widget.repository.getPDF();
    _numero = await FormRepository.getNumeroConstat();
    _vehicule = await FormRepository.getVehiculeConstat();
  }

  void loadOffLine() async {
    final list = await widget.localConstatStorage.constats();
    _hasOffline = list.isNotEmpty;
    if (_hasOffline) {
      saveConstat = list[0];
    }
  }

  void takePicture({String numero}) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    await widget.repository.uploadPicture(file: image, numero: numero);
    setState(() {
      pictureCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _currentIndex > 1
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (_currentIndex == 1) {
                  widget.formRepository.conducteur.persist();
                  Fluttertoast.showToast(
                      msg: "Informations du permis enregistré !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 5,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else if (_currentIndex == 0) {
                  //Persist assurance
                  widget.formRepository.assurance.persist();
                  Fluttertoast.showToast(
                      msg: "Information sur l'assurance enregistré !",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 5,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 14.0);
                }
              },
              child: Icon(Icons.save),
            ),
      appBar: AppBar(
          title: Text(
        "Mes informations personnelles",
        style: TextStyle(fontSize: 14.0),
      )),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_late), title: Text("Assurance")),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car), title: Text("Permis")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin), title: Text("Constat")),
            BottomNavigationBarItem(
                icon: Icon(Icons.offline_bolt), title: Text("Offline"))
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
                  numero: _numero,
                  pdfURL: snapshot.data,
                  vehicule: _vehicule)[_currentIndex];
            }
            if (snapshot.hasError) {
              return getPages(
                  numero: _numero,
                  pdfURL: snapshot.data,
                  vehicule: _vehicule)[_currentIndex];
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
