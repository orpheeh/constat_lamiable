import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:flutter/material.dart';

import 'home/home_page.dart';

void main() {
  final FormRepository formRepository = FormRepository();
  final FormRepository formRepository2 = FormRepository();
  final Repository repository = Repository();

  runApp(MyApp(
    formRepository: formRepository,
    formRepository2: formRepository2,
    repository: repository,
  ));
}

class MyApp extends StatelessWidget {
  final FormRepository formRepository;
  final FormRepository formRepository2;
  final Repository repository;

  const MyApp(
      {Key key, this.formRepository, this.formRepository2, this.repository})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Constat à l'amiable",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        formRepository: formRepository,
        formRepository2: formRepository2,
        repository: repository,
      ),
    );
  }
}