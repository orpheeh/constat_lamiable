import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:constat_lamiable/constat_1_smartphone/constat_with_1_phone.dart';
import 'package:constat_lamiable/constat_2_smartphone/constat_with_two_phone.dart';
import 'package:constat_lamiable/profil/profil.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final FormRepository formRepository;
  final FormRepository formRepository2;
  final Repository repository;

  const HomePage(
      {Key key,
      @required this.formRepository,
      @required this.formRepository2,
      @required this.repository})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Constat à l'amiable"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Constat1PhonePage(
                                repository: widget.repository,
                                formRepository: {
                                  "A": widget.formRepository,
                                  "B": widget.formRepository2
                                })));
              },
              padding: EdgeInsets.all(16.0),
              color: Colors.blue,
              textColor: Colors.white,
              child: Row(
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
            padding: const EdgeInsets.all(16.0),
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
              padding: EdgeInsets.all(16.0),
              color: Colors.blue,
              textColor: Colors.white,
              child: Row(
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
        ],
      ),
    );
  }
}
