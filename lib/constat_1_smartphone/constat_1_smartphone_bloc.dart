import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:constat_lamiable/common/repository.dart';
import 'package:flutter/material.dart';

class Constat1Bloc extends Bloc<Constat1Event, Constat1State> {
  final Repository repository;

  Constat1Bloc({@required this.repository});
  @override
  Constat1State get initialState => Constat1Loading();

  @override
  Stream<Constat1State> mapEventToState(Constat1Event event) async* {
    if (event is Constat1Started) {
      yield Constat1Loading();
      try {
        //Create constat
        final String numero = await repository.createConstat();
        dispatch(Constat1StartForm(numero: numero, vehicule: "A"));
      } catch (error) {
        yield Constat1Failure(error: error.toString());
      }
    }

    if (event is Constat1StartForm) {
      yield Constat1Loading();
      yield Constat1Initial(numero: event.numero, vehicule: event.vehicule);
    }

    if (event is WriteFormFinishEvent) {
      yield Constat1Loading();
      yield Constat1SignatureState(
          formRepository: event.formRepository,
          numero: event.numero,
          vehicule: event.vehicule);
    }

    if (event is CameraTakePictureButtonPressed) {
      yield Constat1Loading();
      try {
        var image = event.file;
        await repository.uploadPicture(file: image, numero: event.numero);

        event.formRepository.pictureCount++;
        yield Constat1Initial(
            numero: event.numero,
            vehicule: event.vehicule,
            scrollPercentInital: 8.0);
      } catch (error) {
        yield Constat1Failure(error: error.toString());
      }
    }

    if (event is TakePictureButtonPressed) {
      yield Constat1Loading();

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

        yield Constat1CameraPreview(
            controller: controller,
            initializeControllerFuture: _initializeControllerFuture,
            formRepository: event.formRepository,
            numero: event.numero,
            vehicule: event.vehicule);
      } catch (error) {
        yield Constat1Failure(error: error.toString());
      }
    }

    if (event is Constat1SendForm) {
      yield Constat1Loading();

      try {
        //Send form to server
        Map<String, bool> result = await repository.sendForm(
            numero: event.numero,
            vehicule: event.vehicule,
            recap: event.formRepository.getRecap());
        //verify result
        if (result["A"] && result["B"]) {
          //  Show constat1Finish
          yield Constat1Finish(numero: event.numero);
        } else {
          yield Constat1Initial(numero: event.numero, vehicule: "B");
        }
        //If on result, vehiculeA.finish == true and vehiculeB.finish == true
        //Else start new form
      } catch (error) {
        yield Constat1Failure(error: error.toString());
      }
    }
  }
}

class Constat1State {}

class Constat1Loading extends Constat1State {}

class Constat1CameraPreview extends Constat1State {
  final CameraController controller;
  final Future<void> initializeControllerFuture;
  final FormRepository formRepository;
  final String numero;
  final String vehicule;

  Constat1CameraPreview(
      {this.formRepository,
      this.numero,
      this.vehicule,
      this.initializeControllerFuture,
      this.controller});
}

class Constat1SignatureState extends Constat1State {
  final String numero;
  final String vehicule;
  final FormRepository formRepository;

  Constat1SignatureState(
      {@required this.numero,
      @required this.vehicule,
      @required this.formRepository});
}

class Constat1Failure extends Constat1State {
  final String error;

  Constat1Failure({this.error});
}

class Constat1Initial extends Constat1State {
  final String vehicule;
  final String numero;
  final double scrollPercentInital;

  Constat1Initial(
      {@required this.numero,
      @required this.vehicule,
      this.scrollPercentInital = 0.0});
}

class Constat1Finish extends Constat1State {
  final String numero;

  Constat1Finish({@required this.numero});
}

class Constat1Event {}

class Constat1Started extends Constat1Event {}

class Constat1StartForm extends Constat1Event {
  final String vehicule;
  final String numero;

  Constat1StartForm({@required this.numero, @required this.vehicule});
}

class Constat1SendForm extends Constat1Event {
  final String numero;
  final String vehicule;
  final FormRepository formRepository;

  Constat1SendForm(
      {@required this.formRepository,
      @required this.numero,
      @required this.vehicule});
}

class TakePictureButtonPressed extends Constat1Event {
  final String numero;
  final String vehicule;
  final FormRepository formRepository;
  final double scrollPercent;

  TakePictureButtonPressed(
      {@required this.formRepository,
      @required this.scrollPercent,
      @required this.numero,
      @required this.vehicule});
}

class CameraTakePictureButtonPressed extends Constat1Event {
  final File file;
  final FormRepository formRepository;
  final String numero;
  final String vehicule;

  CameraTakePictureButtonPressed(
      {this.formRepository, this.numero, this.vehicule, this.file});
}

class WriteFormFinishEvent extends Constat1Event {
  final String numero;
  final String vehicule;
  final FormRepository formRepository;

  WriteFormFinishEvent(
      {@required this.numero,
      @required this.vehicule,
      @required this.formRepository});
}
