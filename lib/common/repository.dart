import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Repository {
  static const IP = "http://192.168.100.216:3000";

  Future<String> createConstat() async {
    final response = await http.post(IP + "/constat/create", body: {});

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["newConstat"]["numero"];
    } else {
      throw Exception("Error on create constat ${response.statusCode}");
    }
  }

  Future<Map<String, bool>> sendForm(
      {final String vehicule,
      final String numero,
      final Map<String, dynamic> recap}) async {
    final response = await http.post(IP + "/constat/send",
        headers: {"content-type": "application/json"},
        body: jsonEncode(
            {"form": recap, "vehicule": vehicule, "numero": numero}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      return {
        "A": result["update"]["vehiculeA"]["finish"],
        "B": result["update"]["vehiculeB"]["finish"]
      };
    } else {
      throw Exception("Error on send form $vehicule ${response.statusCode}");
    }
  }

  Future<void> uploadPicture(
      {File file, String numero}) async {
    print("prepare send image");
    if (file == null) return;
    print("send image");
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;

    final response = await http.post(IP + "/constat/picture",
        headers: {"content-type": "application/json"},
        body: jsonEncode(
            {"image": base64Image, "name": fileName, "numero": numero}));
    if (response.statusCode != 200) {
      throw Exception('upload image error !');
    }
  }
}
