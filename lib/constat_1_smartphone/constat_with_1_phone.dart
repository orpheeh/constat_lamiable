import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:constat_lamiable/common/form.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'constat_1_smartphone_bloc.dart';

class Constat1PhonePage extends StatefulWidget {
  final Map<String, FormRepository> formRepository;
  final Repository repository;

  const Constat1PhonePage(
      {Key key, this.formRepository, @required this.repository})
      : super(key: key);
  @override
  _Constat1PhonePageState createState() => _Constat1PhonePageState();
}

class _Constat1PhonePageState extends State<Constat1PhonePage> {
  final StreamController streamController = new StreamController();
  var blocContext;

  @override
  void initState() {
    super.initState();

    streamController.stream.listen((data) {
      if (data["type"] == 0) {
        BlocProvider.of<Constat1Bloc>(blocContext).dispatch(
            TakePictureButtonPressed(
                scrollPercent: 1.0,
                numero: data["numero"],
                vehicule: data["vehicule"],
                formRepository: widget.formRepository[data["vehicule"]]));
      } else {
        BlocProvider.of<Constat1Bloc>(blocContext).dispatch(Constat1SendForm(
            numero: data["numero"],
            vehicule: data["vehicule"],
            formRepository: widget.formRepository[data["vehicule"]]));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocProvider<Constat1Bloc>(
      builder: (context) => Constat1Bloc(repository: widget.repository)
        ..dispatch(Constat1Started()),
      child: BlocBuilder<Constat1Bloc, Constat1State>(
        builder: (BuildContext context, Constat1State state) {
          if (state is Constat1Loading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is Constat1Initial) {
            blocContext = context;
            return Scaffold(
              appBar: AppBar(
                title: Text("Vehicule ${state.vehicule}"),
              ),
              body: ConstatForm(
                formRepository: widget.formRepository[state.vehicule],
                sink: streamController.sink,
                numero: state.numero,
                vehicule: state.vehicule,
                scrollPercentInitial: state.scrollPercentInital,
              ),
            );
          }

          if (state is Constat1CameraPreview) {
            return Scaffold(
              // Wait until the controller is initialized before displaying the
              // camera preview. Use a FutureBuilder to display a loading spinner
              // until the controller has finished initializing.
              body: FutureBuilder<void>(
                future: state.initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(state.controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.camera_alt),
                // Provide an onPressed callback.
                onPressed: () async {
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  try {
                    // Ensure that the camera is initialized.
                    await state.initializeControllerFuture;

                    // Construct the path where the image should be saved using the
                    // pattern package.
                    final path = join(
                      // Store the picture in the temp directory.
                      // Find the temp directory using the `path_provider` plugin.
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now().millisecondsSinceEpoch}.png',
                    );


                    // Attempt to take a picture and log where it's been saved.
                    await state.controller.takePicture(path);

                    BlocProvider.of<Constat1Bloc>(context).dispatch(
                        CameraTakePictureButtonPressed(
                            formRepository: state.formRepository,
                            numero: state.numero,
                            vehicule: state.vehicule,
                            file: File(path)));
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                  }
                },
              ),
            );
          }

          if (state is Constat1Finish) {
            FormRepository.persistNumeroConstat(state.numero);

            return Scaffold(
                body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  Text(
                    "Constat à l'amiable",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text:
                                    "Votre constat à l'amiable à bien été enregistré."),
                            TextSpan(
                                text:
                                    "Vous pouvez en télécharger une copie en vous rendant sur le site de constat à l'amiable")
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("Site internet de constat à l'amiable"),
                  ),
                  Text(" www.constat-amiable.ga",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("Numero de votre constat"),
                  ),
                  Text("${state.numero}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Retour à l'acceuil"),
                    ),
                  )
                ],
              ),
            ));
          }

          if (state is Constat1Failure) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Icon(Icons.error, color: Colors.grey, size: 32.0,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Une erreur c'est produite soit parce que vous n'êtes pas connecté au réseaux soit parce que vous n'avez pas remplis tous les champs",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Dans tous les cas, nous vous conseillons de vérifier votre connexion et recommencer, merci.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text("Retour à l'accueil"),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Text("Nothing"),
          );
        },
      ),
    );
  }
}
