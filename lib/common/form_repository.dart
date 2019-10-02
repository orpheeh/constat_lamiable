import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'form_content/drawing_table.dart';

class FormRepository {

  static const String KEY_NUM_CONSTAT = "numero_constat";

  static Future<void> persistNumeroConstat(String numero) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(KEY_NUM_CONSTAT, numero);
  }

  static Future<String> getNumeroConstat() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey(KEY_NUM_CONSTAT)){
      return sharedPreferences.getString(KEY_NUM_CONSTAT);
    } else {

      return "";
    }
  }

  FormRepository() {
    assurance.load();
    conducteur.load();
  }

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
          if (croquis.points[index] == null) {
            return null;
          } else {
            return {"x": croquis.points[index].x, "y": croquis.points[index].y};
          }
        }),
        "signature": List.generate(points.length, (index) {
          if (points[index] == null) {
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
  static const KEY_NAME = "assurance_nom";
  static const KEY_FIRST_NAME = "assurance_prenom";
  static const KEY_BP = "assurance_bp";
  static const KEY_TEL = "assurance_tel";
  static const KEY_ADRESSE = "assurance_addr";
  static const KEY_STE_ASSURANCE = "ste_assurance";
  static const KEY_NUM_POLICE = "assurance_police";
  static const KEY_NUM_CR = "assurance_cr";
  static const KEY_AG = "assurance_ag";
  static const KEY_VAL_DU = "assurance_du";
  static const KEY_VAL_AU = "assurance_au";

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

  Future<void> persist() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(KEY_NAME, nom);
    sharedPreferences.setString(KEY_FIRST_NAME, prenom);
    sharedPreferences.setString(KEY_ADRESSE, adresse);
    sharedPreferences.setString(KEY_BP, bp);
    sharedPreferences.setString(KEY_TEL, tel);
    sharedPreferences.setString(KEY_NUM_POLICE, numeroPolice);
    sharedPreferences.setString(KEY_NUM_CR, numeroCarteRose);
    sharedPreferences.setString(KEY_AG, agenceCourtier);
    sharedPreferences.setInt(KEY_VAL_DU, valableDu.millisecondsSinceEpoch);
    sharedPreferences.setInt(KEY_VAL_AU, valableAu.millisecondsSinceEpoch);
  }

  Future<void> load() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey(KEY_NAME)) {
      return;
    }
    this.nom = sharedPreferences.getString(KEY_NAME);
    this.prenom = sharedPreferences.getString(KEY_FIRST_NAME);
    this.adresse = sharedPreferences.getString(KEY_ADRESSE);
    this.bp = sharedPreferences.getString(KEY_BP);
    this.tel = sharedPreferences.getString(KEY_TEL);
    this.numeroPolice = sharedPreferences.getString(KEY_NUM_POLICE);
    this.numeroCarteRose = sharedPreferences.getString(KEY_NUM_CR);
    this.agenceCourtier = sharedPreferences.getString(KEY_AG);
    this.valableDu = DateTime.fromMicrosecondsSinceEpoch(
        sharedPreferences.getInt(KEY_VAL_DU));
    this.valableAu = DateTime.fromMicrosecondsSinceEpoch(
        sharedPreferences.getInt(KEY_VAL_AU));
  }
}

class Conducteur {
  static const KEY_NAME = "permis_nom";
  static const KEY_FIRST_NAME = "permis_prenom";
  static const KEY_CYCLO = "permis_cyclo";
  static const KEY_TEL = "permis_tel";
  static const KEY_ADRESSE = "permis_addr";
  static const KEY_NUM = "permis_numero";
  static const KEY_CAT = "permis_cat";
  static const KEY_DEL = "permis_del";
  static const KEY_DEL_PAR = "permis_del_par";
  static const KEY_DATE_VAL = "permis_val";

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

  Future<void> persist() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(KEY_NAME, nom);
    sharedPreferences.setString(KEY_FIRST_NAME, prenom);
    sharedPreferences.setString(KEY_ADRESSE, adresse);
    sharedPreferences.setString(KEY_CYCLO, licenceCyclomoteur);
    sharedPreferences.setString(KEY_TEL, telephone);
    sharedPreferences.setString(KEY_NUM, numeroPermisConduire);
    sharedPreferences.setString(KEY_CAT, category);
    sharedPreferences.setInt(KEY_DEL, delivrer.millisecondsSinceEpoch);
    sharedPreferences.setString(KEY_DEL_PAR, delivrerPar);
    sharedPreferences.setInt(KEY_DATE_VAL, dateValidite.millisecondsSinceEpoch);
  }

  Future<void> load() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey(KEY_NAME)) {
      return;
    }
    this.nom = sharedPreferences.getString(KEY_NAME);
    this.prenom = sharedPreferences.getString(KEY_FIRST_NAME);
    this.adresse = sharedPreferences.getString(KEY_ADRESSE);
    this.licenceCyclomoteur = sharedPreferences.getString(KEY_CYCLO);
    this.telephone = sharedPreferences.getString(KEY_TEL);
    this.numeroPermisConduire = sharedPreferences.getString(KEY_NUM);
    this.category = sharedPreferences.getString(KEY_CAT);
    this.delivrer =
        DateTime.fromMillisecondsSinceEpoch(sharedPreferences.getInt(KEY_DEL));
    this.delivrerPar = sharedPreferences.getString(KEY_DEL_PAR);
    this.dateValidite = DateTime.fromMillisecondsSinceEpoch(
        sharedPreferences.getInt(KEY_DATE_VAL));
  }
}

class Circonstance {
  final String description;
  bool isSelected = false;

  Circonstance({this.description});
}
