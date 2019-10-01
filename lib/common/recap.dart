import 'package:constat_lamiable/common/degat_indicator.dart';
import 'package:constat_lamiable/common/form_content/drawing_table.dart';
import 'package:constat_lamiable/common/form_repository.dart';
import 'package:flutter/material.dart';

class Recap extends StatefulWidget {
  final FormRepository formRepository;

  const Recap({Key key, this.formRepository}) : super(key: key);
  @override
  _RecapState createState() => _RecapState();
}

class _RecapState extends State<Recap> {
  Map<String, dynamic> recap;

  @override
  Widget build(BuildContext context) {
    recap = widget.formRepository.getRecap();
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Date et heure de l'accident",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${recap["date"]} à ${recap["heure"]}")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Lieu précis",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  "${widget.formRepository.context.lieuPrecis}, ${widget.formRepository.context.ville}")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "blésses même légers",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(recap["blesser"] ? "Oui" : "Non")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Dégât matériel autres qu'aux vehicules A et B",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(recap["degat_mat"] ? "Oui" : "Non")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            height: 2,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Point de choc inital",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DegatIndicator(
            formRepository: widget.formRepository,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Dégats apparent",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${recap["degat"]["degat_app"]}")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Observations",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${recap["degat"]["observation"]}")
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 250,
          child: CustomPaint(
              painter: DrawingTable(
                  points: widget.formRepository.croquis.points,
                  repaint: false)),
        )
      ],
    );
  }
}
