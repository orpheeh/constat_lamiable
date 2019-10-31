import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/offline/local_constat_storage.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:constat_lamiable/constat_1_smartphone/constat_with_1_phone.dart';
import 'package:constat_lamiable/constat_2_smartphone/constat_with_two_phone.dart';
import 'package:constat_lamiable/profil/profil.dart';
import 'package:constat_lamiable/profil/setting.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final FormRepository formRepository;
  final FormRepository formRepository2;
  final Repository repository;
  final LocalConstatStorage localConstatStorage;

  const HomePage(
      {Key key,
      @required this.formRepository,
      @required this.formRepository2,
      @required this.repository,
      @required this.localConstatStorage})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Constat amiable",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            formRepository: widget.formRepository,
                            localConstatStorage: widget.localConstatStorage,
                            repository: widget.repository,
                          )));
            },
            icon: Icon(
              Icons.person,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Vous venez d'avoir un accident ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 32.0),
                      child: Text(
                        "Ne vous fâchez pas, mettez vous en sécurité et remplissez le constat à l'amiable",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 16.0, top: 4.0),
                      child: Text(
                        "Vous pouvez utiliser un smartphone et remplir deux fois le questionnaire dessus ou vous pouvez utiliser deux smartphones, un pour chaque conducteur",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.grey[500]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Constat1PhonePage(
                                          repository: widget.repository,
                                          localConstatStorage:
                                              widget.localConstatStorage,
                                          formRepository: {
                                            "A": widget.formRepository,
                                            "B": widget.formRepository2
                                          })));
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phone_android,
                            ),
                            Text("Utiliser 1 smartphone")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Constat2PhonePage(
                                        formRepository: widget.formRepository,
                                        repository: widget.repository,
                                      )));
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phone_android,
                            ),
                            Icon(
                              Icons.phone_android,
                            ),
                            Text("Utiliser 2 smartphones")
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
            Text(
              "\u00A9 SING SA",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 10.0),
            )
          ],
        ),
      ),
    );
  }
}
