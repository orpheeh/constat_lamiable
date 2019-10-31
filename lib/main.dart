import 'package:bloc/bloc.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/offline/local_constat_storage.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:flutter/material.dart';

import 'home/home_page.dart';

void main() async {
  final FormRepository formRepository = FormRepository();
  final FormRepository formRepository2 = FormRepository();
  final Repository repository = Repository();
  final LocalConstatStorage localConstatStorage = new LocalConstatStorage();
  await localConstatStorage.init();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MyApp(
    formRepository: formRepository,
    formRepository2: formRepository2,
    localConstatStorage: localConstatStorage,
    repository: repository,
  ));
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('$error, $stacktrace');
  }
}

class MyApp extends StatelessWidget {
  final FormRepository formRepository;
  final FormRepository formRepository2;
  final Repository repository;
  final LocalConstatStorage localConstatStorage;

  const MyApp(
      {Key key,
      this.formRepository,
      this.formRepository2,
      this.repository,
      @required this.localConstatStorage})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Constat à l'amiable",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        formRepository: formRepository,
        formRepository2: formRepository2,
        localConstatStorage: localConstatStorage,
        repository: repository,
      ),
    );
  }
}
