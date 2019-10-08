import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:flutter/material.dart';

class Constat2Bloc extends Bloc<Constat2Event, Constat2State> {
  final Repository repository;

  Constat2Bloc({@required this.repository});
  @override
  Constat2State get initialState => Constat2Loading();

  @override
  Stream<Constat2State> mapEventToState(Constat2Event event) async* {
    if (event is Constat2Started) {
      yield Constat2Loading();

      yield Constat2InitialState(formRepository: event.formRepository);
    }

    if (event is TakePictureButtonPressed2) {
      yield Constat2Loading();

      try {
        // Obtain a list of the available cameras on the device.
        final cameras = await availableCameras();

        // Get a specific camera from the list of available cameras.
        final firstCamera = cameras.first;

        CameraController controller;
        controller = CameraController(
          // Get a specific camera from the list of available cameras.
          firstCamera,
          // Define the resolution to use.
          ResolutionPreset.medium,
        );

        Future<void> _initializeControllerFuture = controller.initialize();

        yield Constat2CameraPreview(
            controller: controller,
            initializeControllerFuture: _initializeControllerFuture,
            formRepository: event.formRepository,
            numero: event.numero,
            vehicule: event.vehicule);
      } catch (error) {
        yield Constat2Failure(error: error.toString());
      }
    }

    if (event is Constat2ScanQRCodeButtonPressed) {
      yield Constat2Loading();

      try {
        String data = await BarcodeScanner.scan();
        String numero = data.split(':')[0];
        String vehicule = data.split(':')[1] == 'A' ? 'B' : 'A';
        if (numero == null || numero == "") {
          yield Constat2InitialState(formRepository: event.formRepository);
        } else {
          yield Constat2Form(
              numero: numero,
              vehicule: vehicule,
              formRepository: event.formRepository,
              scrollPercentInital: 0.0);
        }
      } catch (error) {
        yield Constat2InitialState(formRepository: event.formRepository);
      }
    }

    if (event is CameraTakePictureButtonPressed2) {
      yield Constat2Loading();
      try {
        var image = event.file;
        await repository.uploadPicture(file: image, numero: event.numero);

        event.formRepository.pictureCount++;
        yield Constat2Form(
            formRepository: event.formRepository,
            numero: event.numero,
            vehicule: event.vehicule,
            scrollPercentInital: 8.0);
      } catch (error) {
        yield Constat2Failure(error: error.toString());
      }
    }

    if (event is Constat2SendForm) {
      yield Constat2Loading();

      try {
        //Send form to server
        await repository.sendForm(
            numero: event.numero,
            vehicule: event.vehicule,
            recap: event.formRepository.getRecap());
        //verify result
        yield Constat2Finish(numero: event.numero, vehicule: event.vehicule);
        //If on result, vehiculeA.finish == true and vehiculeB.finish == true
        //Else start new form
      } catch (error) {
        yield Constat2Failure(error: error.toString());
      }
    }

    if (event is Constat2GenQRCodeButtonPressed) {
      yield Constat2Loading();

      try {
        String numero = await repository.createConstat();
        yield Constat2QRCodeState(numero: numero);
      } catch (error) {}
    }

    if (event is Constat2WriteFormButtonPressed) {
      yield Constat2Loading();

      yield Constat2Form(
          formRepository: event.formRepository,
          vehicule: event.vehicule,
          numero: event.numero);
    }
  }
}

class Constat2State {}

class Constat2InitialState extends Constat2State {
  final FormRepository formRepository;

  Constat2InitialState({@required this.formRepository});
}

class Constat2QRCodeState extends Constat2State {
  final FormRepository fromRepository;
  final String numero;

  Constat2QRCodeState({this.fromRepository, this.numero});
}

class Constat2Finish extends Constat2State {
  final String numero;
  final String vehicule;

  Constat2Finish({@required this.vehicule, @required this.numero});
}

class Constat2Form extends Constat2State {
  final FormRepository formRepository;
  final String numero;
  final String vehicule;
  final double scrollPercentInital;

  Constat2Form(
      {this.scrollPercentInital = 0.0,
      @required this.formRepository,
      @required this.numero,
      @required this.vehicule});
}

class Constat2Loading extends Constat2State {}

class Constat2Failure extends Constat2State {
  final String error;

  Constat2Failure({this.error});
}

class Constat2Event {}

class Constat2Started extends Constat2Event {
  final FormRepository formRepository;

  Constat2Started({@required this.formRepository});
}

class Constat2GenQRCodeButtonPressed extends Constat2Event {}

class Constat2WriteFormButtonPressed extends Constat2Event {
  final String vehicule;
  final String numero;
  final FormRepository formRepository;

  Constat2WriteFormButtonPressed(
      {@required this.vehicule,
      @required this.numero,
      @required this.formRepository});
}

class Constat2ScanQRCodeButtonPressed extends Constat2Event {
  final FormRepository formRepository;

  Constat2ScanQRCodeButtonPressed({@required this.formRepository});
}

class TakePictureButtonPressed2 extends Constat2Event {
  final String vehicule;
  final String numero;
  final FormRepository formRepository;
  final double scrollPercent;

  TakePictureButtonPressed2(
      {this.scrollPercent,
      @required this.vehicule,
      @required this.numero,
      @required this.formRepository});
}

class Constat2CameraPreview extends Constat2State {
  final CameraController controller;
  final Future<void> initializeControllerFuture;
  final FormRepository formRepository;
  final String numero;
  final String vehicule;

  Constat2CameraPreview(
      {this.formRepository,
      this.numero,
      this.vehicule,
      this.initializeControllerFuture,
      this.controller});
}

class CameraTakePictureButtonPressed2 extends Constat2Event {
  final File file;
  final FormRepository formRepository;
  final String numero;
  final String vehicule;

  CameraTakePictureButtonPressed2(
      {this.formRepository, this.numero, this.vehicule, this.file});
}

class Constat2SendForm extends Constat2Event {
  final String vehicule;
  final String numero;
  final FormRepository formRepository;

  Constat2SendForm(
      {@required this.vehicule,
      @required this.numero,
      @required this.formRepository});
}
