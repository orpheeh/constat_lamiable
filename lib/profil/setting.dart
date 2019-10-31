import 'package:constat_lamiable/common/repository.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _ipController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _ipController.text = Repository.IP;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Internet"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (v) {
                Repository.IP = v;
              },
              controller: _ipController,
              decoration: InputDecoration(labelText: "Adresse IP du serveur"),
            ),
          )
        ],
      ),
    );
  }
}
