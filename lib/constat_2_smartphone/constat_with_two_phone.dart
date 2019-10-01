import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:constat_lamiable/common/form.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:constat_lamiable/constat_2_smartphone/constat_2_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart';

class Constat2PhonePage extends StatefulWidget {
  final FormRepository formRepository;
  final Repository repository;

  const Constat2PhonePage(
      {Key key, @required this.formRepository, @required this.repository})
      : super(key: key);
  @override
  _Constat2PhonePageState createState() => _Constat2PhonePageState();
}

class _Constat2PhonePageState extends State<Constat2PhonePage> {
  final StreamController streamController = new StreamController();
  var blocContext;

  @override
  void initState() {
    super.initState();

    streamController.stream.listen((data) {
      if (data["type"] == 0) {
        BlocProvider.of<Constat2Bloc>(blocContext).dispatch(
            TakePictureButtonPressed2(
                scrollPercent: 1.0,
                numero: data["numero"],
                vehicule: data["vehicule"],
                formRepository: widget.formRepository));
      } else {
        BlocProvider.of<Constat2Bloc>(blocContext).dispatch(Constat2SendForm(
            numero: data["numero"],
            vehicule: data["vehicule"],
            formRepository: widget.formRepository));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<Constat2Bloc>(
      builder: (context) => Constat2Bloc(repository: widget.repository)
        ..dispatch(Constat2Started(formRepository: widget.formRepository)),
      child: BlocBuilder<Constat2Bloc, Constat2State>(
        builder: (context, state) {
          if (state is Constat2Loading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is Constat2InitialState) {
            blocContext = context;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<Constat2Bloc>(context)
                            .dispatch(Constat2GenQRCodeButtonPressed());
                      },
                      child: Text("Générer un QR code"),
                    ),
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<Constat2Bloc>(context).dispatch(
                            Constat2ScanQRCodeButtonPressed(
                                formRepository: widget.formRepository));
                      },
                      child: Text("Scanner un QR code"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is Constat2Failure) {
            return Scaffold(
              body: Center(
                child: Text("${state.error}"),
              ),
            );
          }

          if (state is Constat2Finish) {
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

          if (state is Constat2QRCodeState) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Attendez que l'autre scan le QRCode avant de remplir le formulaire"),
                    ),
                    Center(
                      child: QrImage(
                        data: state.numero,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<Constat2Bloc>(context).dispatch(
                            Constat2WriteFormButtonPressed(
                                formRepository: widget.formRepository,
                                vehicule: "A",
                                numero: state.numero));
                      },
                      child: Text("Remplir le formulaire"),
                    )
                  ],
                ),
              ),
            );
          }

          if (state is Constat2CameraPreview) {
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

                    BlocProvider.of<Constat2Bloc>(context).dispatch(
                        CameraTakePictureButtonPressed2(
                            formRepository: state.formRepository,
                            numero: state.numero,
                            vehicule: state.vehicule,
                            file: File(path)));
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
              ),
            );
          }

          if (state is Constat2Form) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Vehicule ${state.vehicule}"),
              ),
              body: ConstatForm(
                formRepository: widget.formRepository,
                sink: streamController.sink,
                numero: state.numero,
                vehicule: state.vehicule,
                scrollPercentInitial: state.scrollPercentInital,
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
