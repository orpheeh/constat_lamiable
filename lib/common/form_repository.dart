import 'package:flutter/material.dart';

import 'form_content/drawing_table.dart';

class FormRepository {
  //Vehicule
  final List<CarType> carTypes = [
    CarType(name: "car", asset: "assets/images/car.png"),
    CarType(name: "moto", asset: "assets/images/moto.png"),
    CarType(name: "bus", asset: "assets/images/bus.png")
  ];
  int currentCarIndex = -1;
  String numeroImmatriculation;
  String numeroMoteur;

  //For receive PDF
  String email;

  //Contexte
  final Context context = new Context();

  //Assurance
  final Assurance assurance = new Assurance();

  //Conducteur
  final Conducteur conducteur = new Conducteur();

  //Degat
  final Degat degat = new Degat();

  //Croquis
  final Croquis croquis = new Croquis();

  //Signature
  final List<Point> points = [];

  //Picture Count
  int pictureCount = 0;

  //Circonstance
  final List<Circonstance> circonstances = [
    Circonstance(description: "roulait dans le même sens et sur la même file"),
    Circonstance(
        description: "roulait dans le même sens et sur une file différente"),
    Circonstance(description: "roulait en sens inverse"),
    Circonstance(description: "provenant d'une voie différente"),
    Circonstance(description: "s'engageait sur une place à sens giratoire"),
    Circonstance(description: "roulait sur une place à sens giratoire"),
    Circonstance(description: "à l'arrêt"),
    Circonstance(description: "en stationnement"),
    Circonstance(description: "en stationnement en double file"),
    Circonstance(description: "en stationnement hors agglomération"),
    Circonstance(description: "avançait"),
    Circonstance(description: "reculait"),
    Circonstance(description: "doublant(dépassait)"),
    Circonstance(description: "changeait de file"),
    Circonstance(description: "virait à droite"),
    Circonstance(description: "virait à gauche"),
    Circonstance(description: "virait à une flèche de dégagement"),
    Circonstance(description: "quittait un stationnement"),
    Circonstance(description: "allait au stationnement"),
    Circonstance(
        description:
            "s'engageait dans un parking, un lieu privé, route non ouverte à la circulation"),
    Circonstance(
        description:
            "sortait d'un parking, un lieu privé, route non ouverte à la circulation"),
    Circonstance(
        description:
            "empiétait sur la partie de voie  réservée à la circulation en sens inverse"),
    Circonstance(description: "roulait en sens interdit"),
    Circonstance(description: "inobservation d'un signal de priorité"),
    Circonstance(description: "inobservation d'un signal de stop"),
    Circonstance(description: "faisait un demi-tour"),
    Circonstance(description: "ouvrait une portiaire"),
  ];

  List<int> getSelectedCirconstances() {
    List<int> list = [];
    for (int i = 0; i < circonstances.length; i++) {
      if (circonstances[i].isSelected) {
        list.add(i);
      }
    }
    return list;
  }

  Map<String, dynamic> getRecap() => {
        "date": context.date.toIso8601String().split('T')[0],
        "heure": "${context.time.hour}:${context.time.minute}",
        "lieu":
            "${context.location["lat"]};${context.location["lng"]};${context.lieuPrecis}",
        "ville": context.ville,
        "blesser": degat.blesser,
        "degat_mat": degat.degatMateriel,
        "temoins": context.temoinToJson(),
        "venant_de": context.venantDe,
        "allant_vers": context.allantVers,
        "marque": currentCarIndex,
        "num_imm": numeroImmatriculation,
        "num_moteur": numeroMoteur,
        "use_remorque": currentCarIndex >= 0
            ? carTypes[currentCarIndex].useRemorque
            : false,
        "assurance": assurance.toJson(),
        "conducteur": conducteur.toJson(),
        "degat": {
          "choc_init": degat.chocInitial.index,
          "degat_app": degat.degatApparents,
          "observation": degat.observations,
        },
        "circonstance": getSelectedCirconstances(),
        "croquis": List.generate(croquis.points.length, (index) {
          if(croquis.points[index] == null){
            return null;
          } else {
            return {"x": croquis.points[index].x, "y": croquis.points[index].y};
          }
        }),
        "signature":List.generate(points.length, (index) {
          if(points[index] == null){
            return null;
          } else {
            return {"x": points[index].x, "y": points[index].y};
          }
        }),
      };
}

class CarType {
  final String name;
  final String asset;
  bool useRemorque = false;

  CarType({this.name, this.asset});
}

class Croquis {
  final List<Point> points = [];
}

class Context {
  DateTime date;
  TimeOfDay time;
  Map<String, double> location = {"lat": 0.0, "lng": 0.0};
  List<Temoin> temoins = [];
  String lieuPrecis = "";
  String ville = "";
  String venantDe = "";
  String allantVers = "";

  temoinToJson() =>
      List.generate(temoins.length, (index) => temoins[index].toJson());
}

enum ChocInitial {
  NONE,
  BOTTOM_RIGHT,
  BOTTOM,
  BOTTOM_LEFT,
  LEFT,
  TOP_LEFT,
  TOP,
  TOP_RIGHT,
  RIGHT,
}

class Degat {
  ChocInitial chocInitial = ChocInitial.NONE;
  String degatApparents = "";
  String observations = "";
  bool blesser = false;
  bool degatMateriel = false;
}

class Temoin {
  final String nom;
  final String prenom;
  final String tel;
  final String email;

  Temoin({this.nom, this.prenom, this.tel, this.email});

  Map<String, String> toJson() =>
      {"nom": nom, "prenom": prenom, "tel": tel, "email": email};
}

class Assurance {
  String nom = "";
  String prenom = "";
  String adresse = "";
  String bp = "";
  String tel = "";
  String steAssurance = "Société d'assurance";
  String numeroPolice = "";
  String numeroCarteRose = "";
  String agenceCourtier = "";
  DateTime valableDu;
  DateTime valableAu;

  toJson() => {
        "nom": nom.toUpperCase(),
        "prenom": prenom.toUpperCase(),
        "adresse": adresse,
        "bp": bp,
        "tel": tel,
        "ste_ass": steAssurance,
        "num_police": numeroPolice,
        "num_carte_rose": numeroCarteRose,
        "att_valide_du": valableDu.toIso8601String().split('T')[0],
        "att_valide_au": valableAu.toIso8601String().split('T')[0],
        "ag_courtier": agenceCourtier
      };
}

class Conducteur {
  String nom = "";
  String prenom = "";
  String adresse = "";
  String telephone = "";
  String licenceCyclomoteur = "";
  String numeroPermisConduire = "";
  String category = "Catégorie";
  DateTime delivrer;
  String delivrerPar = "";
  bool taxi = false;
  DateTime dateValidite;

  toJson() => {
        "nom": nom.toUpperCase(),
        "prenom": prenom.toUpperCase(),
        "adresse": adresse,
        "tel": telephone,
        "licence_cyclo": licenceCyclomoteur,
        "permis": numeroPermisConduire,
        "categorie": category,
        "delivre_le": delivrer.toIso8601String().split('T')[0],
        "delivre_par": delivrerPar,
        "valable": dateValidite.toIso8601String().split('T')[0]
      };
}

class Circonstance {
  final String description;
  bool isSelected = false;

  Circonstance({this.description});
}
