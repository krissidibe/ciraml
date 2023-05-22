import 'package:benkan_app/Models/AvisComModel.dart';
import 'package:benkan_app/Models/CercleModel.dart';
import 'package:benkan_app/Models/PostModel.dart';
import 'package:benkan_app/Models/RegionModel.dart';
import 'package:benkan_app/Services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class HttpService {
  static Future<List<Post>> fetchAllPost() async {
    final response = await http
        .get(Uri.parse('https://gestion-benkan.ml/api' + Api.postsAllGet));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];
      List<Post> posts =
          body.map((dynamic item) => Post.fromJson(jsonEncode(item))).toList();

      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<AvisCom>> fetchAllAvis() async {
    final response = await http
        .get(Uri.parse('https://gestion-benkan.ml/api' + Api.avisAllGet));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];
      List<AvisCom> datas = body
          .map((dynamic item) => AvisCom.fromJson(jsonEncode(item)))
          .toList();

      return datas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<AvisCom>> fetchAllVideo() async {
    final response = await http
        .get(Uri.parse('https://gestion-benkan.ml/api' + Api.videosAllGet));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];
      List<AvisCom> datas = body
          .map((dynamic item) => AvisCom.fromJson(jsonEncode(item)))
          .toList();

      return datas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<Region>> fetchAllRegions() async {
    final response = await http
        .get(Uri.parse('https://gestion-benkan.ml/api' + Api.getAllRegions));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];
      List<Region> datas = body
          .map((dynamic item) => Region.fromJson(jsonEncode(item)))
          .toList();

      return datas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<Cercle>> fetchAllCercle({value}) async {
    //print("https://gestion-benkan.ml/api" + Api.getCercle + '/' + value);

    final response = await http.get(Uri.parse(
        'https://gestion-benkan.ml/api' + Api.getCercle + '/' + value));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Cercle> datas = body
          .map((dynamic item) => Cercle.fromJson(jsonEncode(item)))
          .toList();

      return datas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<dynamic>> fetchAllDatas({endpoint, classCall}) async {
    final response =
        await http.get(Uri.parse('https://gestion-benkan.ml/api' + endpoint));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)["data"];
      List<dynamic> datas =
          body.map((dynamic item) => jsonEncode(item)).toList();

      return datas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<dynamic> postAllDatas({required datas}) async {
    var formData = FormData.fromMap({
      'nom': datas["nom"],
      'prenom': datas["prenom"],
      'inOrganisation': datas["inOrganisation"],
      'nina': datas["nina"],
      'carteElec': datas["carteElec"],
      'numero': datas["numero"],
      'email': datas["email"],
      'sexe': datas["genre"],
      'region': datas["region"],
      'cercleComune': datas["cercleComune"],
      'adresse': datas["adresse"],
      'photo': await MultipartFile.fromFile(
        datas["photo"].path,
        filename: "demo.jpg",
      ),
    });
    if (datas["photo"].path == null) {
      return "null";
    }
    try {
      var response = await Dio().post(
          "https://gestion-benkan.ml/api" + Api.postAllAdhesion,
          data: formData);

      return response.statusMessage;
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<bool> verificationCheck({endpoint, value}) async {
    /*   Response response =
        await Dio().get("https://gestion-benkan.ml/api" + endpoint + value);
     
    response.data; */
    final response = await http
        .get(Uri.parse("https://gestion-benkan.ml/api" + endpoint + value));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (response.body == "true") {
        return true;
      } else {
        return false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
