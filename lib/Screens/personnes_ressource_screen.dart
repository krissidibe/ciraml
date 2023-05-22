import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:benkan_app/Models/PostModel.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonnesRessourceScreen extends StatefulWidget {
  const PersonnesRessourceScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PersonnesRessourceScreen> createState() =>
      _PersonnesRessourceScreenState();
}

class _PersonnesRessourceScreenState extends State<PersonnesRessourceScreen> {
  /* 020421 */
  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  TextEditingController codeController = TextEditingController();
  List<dynamic> members = [
    {
      "firstName": "Mamadou Z",
      "lastName": "Sidibé",
      "poste": "Ancien gouverneur & ancien DGA de la Police",
      "tel": "76 48 22 25",
      "lieu": "Bamako",
      "opportunites": "Point d'entrée PACP & stratégie transition",
      "personneContact": "SMC²",
      "image": "assets/icons/profile.png",
      "dateCall": "",
      "isCall": false
    },
    {
      "firstName": "Cheick Ouma",
      "lastName": "Gadjigo",
      "poste":
          "Ancien coordinateur CFR et acteur politique majeur en commune 3",
      "tel": "66 76 92 62",
      "lieu": "Bamako",
      "opportunites": "Possible Fort soutien en commune 3",
      "personneContact": "CNCAS",
      "image": "assets/icons/profile.png",
      "dateCall": "",
      "isCall": false
    },
    {
      "firstName": "Mme Konaté Zeinab",
      "lastName": "Guissé",
      "poste": "Présidente FEMAH / Bamako",
      "tel": "76 03 37 47",
      "lieu": "Bamako",
      "opportunites": "Stratégie Handicap",
      "personneContact": "Oumou Bocoum",
      "image": "assets/icons/profile.png",
      "dateCall": "",
      "isCall": false
    },
    {
      "firstName": "Alkeydi Ibrahima",
      "lastName": "Touré",
      "poste": "Directeur de la stratégie Afrique VACUO et Conseiller Tatam Ly",
      "tel": "77 55 96 96 ",
      "lieu": "Mali / France",
      "opportunites": "Possible relecteur Projet de société",
      "personneContact": "Youba Konaté",
      "image": "assets/icons/profile.png",
      "dateCall": "",
      "isCall": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/logoo.png",
          scale: 16,
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              "Outil de Capitalisation des Grands électeurs et autres personnalités",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              thickness: 1,
              color: Color(0xFFe95022),
            ),
          ),
          SizedBox(
            height: 0,
          ),
          ...members.map(
            (e) => GestureDetector(
              onTap: () {
                _makePhoneCall(e["tel"]);
              },
              child: Stack(children: [
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: new LinearGradient(
                          stops: [0.01, 0.01],
                          colors: e['isCall']
                              ? [Color(0xFFe95022), Colors.white]
                              : [Colors.teal, Colors.white]),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${e['firstName']}",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${e['lastName']}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        e["poste"],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        e["lieu"],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Divider(),
                      Text(
                        e["opportunites"],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Divider(),
                      Text(
                        e["personneContact"],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e["dateCall"].replaceAll("00:00:00.000", ""),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 0, 0))),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.call,
                                color: e["isCall"]
                                    ? Color(0xFFe95022)
                                    : Colors.teal),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    left: 20,
                    top: 10,
                    child: GestureDetector(
                        onTap: () {
                          Get.defaultDialog(
                              title: "Etat d'appel",
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "Vous avez echanger avec l'utilisateur ?"),
                              ),
                              confirm: ElevatedButton(
                                onPressed: () {
                                  DateTime now = new DateTime.now();
                                  var formatter = new DateFormat('dd-MM-yyyy');
                                  DateTime date = new DateTime(
                                      now.year, now.month, now.day);
                                  setState(() {
                                    e["isCall"] = true;
                                    e["dateCall"] = formatter.format(now);
                                    print(members);
                                  });
                                  Get.back();
                                },
                                child: Text("Oui"),
                              ),
                              cancel: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      e["isCall"] = false;
                                      e["dateCall"] = "";
                                      print(members);
                                    });
                                    Get.back();
                                  },
                                  child: Text("Non")));
                        },
                        child: Icon(Icons.edit,
                            color:
                                e["isCall"] ? Color(0xFFe95022) : Colors.teal)))
              ]),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      )),
    );
  }
}
