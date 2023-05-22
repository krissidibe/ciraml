import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:benkan_app/Models/PostModel.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganigrammeScreen extends StatefulWidget {
  const OrganigrammeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OrganigrammeScreen> createState() => _OrganigrammeScreenState();
}

class _OrganigrammeScreenState extends State<OrganigrammeScreen> {
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
      "firstName": "Seydou Mamadou",
      "lastName": "COULIBALY",
      "poste": "Président",
      "tel": "+33689404039",
      "image": "assets/members/president.jpg"
    },
    {
      "firstName": "Diadié Amadou",
      "lastName": "SANKARÉ",
      "poste": "1er Vice-Président",
      "tel": "+22366 74 85 04",
      "image": "assets/members/Amadou-Diadie.jpg"
    },
    {
      "firstName": "Modibo",
      "lastName": "KEÏTA",
      "poste": "2ème Vice-Président",
      "tel": "+22376 15 91 59",
      "image": "assets/members/modibo keita.jpg"
    },
    {
      "firstName": "Amadou Moustaphe",
      "lastName": "DIOP",
      "poste": "3ème Vice-Président",
      "tel": "+22376 40 34 20",
      "image": "assets/members/moustaphe.jpeg"
    },
    {
      "firstName": "Dougou",
      "lastName": "KEÏTA",
      "poste": "4ème Vice-Président",
      "tel": "+22377 47 00 18",
      "image": "assets/members/dougoukeita.jpeg"
    },
    {
      "firstName": "Mahamane",
      "lastName": "TOURÉ",
      "poste": "5ème Vice-Président",
      "tel": "+22366 75 17 15",
      "image": "assets/members/mahamaneT.jpg"
    },
    {
      "firstName": "Alima",
      "lastName": "DABO",
      "poste": "6ème Vice-Président",
      "tel": "+22366 74 93 95",
      "image": "assets/members/alima DABO.jpeg"
    },
    {
      "firstName": "Mamadou Nama",
      "lastName": "KEÏTA",
      "poste": "7ème Vice-Président",
      "tel": "+22366 71 38 80",
      "image": "assets/members/Mamadou-Naman-Keita.jpg"
    },
    {
      "firstName": "Boubacar",
      "lastName": "TANDIA",
      "poste": "8ème Vice-Président",
      "tel": "+22366 74 20 40",
      "image": "assets/members/boubacartandia.jpg"
    },
    {
      "firstName": "Me Yacine ",
      "lastName": "FAYE-SIDIBÉ",
      "poste": "9ème Vice-Président",
      "tel": "+22366 74 37 11",
      "image": "assets/members/meyacine.jpeg"
    },
    {
      "firstName": "Mme Fatimata",
      "lastName": "TRAORE CAMARA",
      "poste": "10ème Vice-Président",
      "tel": "",
      "image": "assets/members/Fatimatatraore.jpg"
    },
    {
      "firstName": "Oussouby",
      "lastName": "SACKO",
      "poste": "11ème Vice-Président",
      "tel": "00818043540076",
      "image": "assets/members/oussouby.jpg"
    },
    {
      "firstName": "Cheick Fanta Mady",
      "lastName": "DIABATÉ",
      "poste": "12ème Vice-Président",
      "tel": "+22366 73 18 18",
      "image": "assets/members/cheickdiabate.jpeg"
    },
    {
      "firstName": "Dr Salif",
      "lastName": "TRAORÉ",
      "poste": "13ème Vice-Président",
      "tel": "+22390 26 97 20",
      "image": "assets/members/saliftraore.jpeg"
    },
    {
      "firstName": "Baba Moulaye",
      "lastName": "HAÏDARA",
      "poste": "14ème Vice-Président",
      "tel": "+22366 75 68 77",
      "image": "assets/members/baba moulaye.jpeg"
    },
    {
      "firstName": "Oumar",
      "lastName": "TRAORÉ",
      "poste": "15ème Vice-Président",
      "tel": "+22375 00 77 99",
      "image": "assets/members/oumartra.jpeg"
    },
    {
      "firstName": "Alkadri",
      "lastName": "Diarra",
      "poste": "16ème Vice-Président",
      "tel": "+223 66 77 72 85",
      "image": "assets/members/Alkadri-Diarra.jpg"
    },
    {
      "firstName": "Bamody",
      "lastName": "Fofana",
      "poste": "19ème Vice-Président",
      "tel": "+223 76 48 61 33",
      "image": "assets/members/vp19.jpg"
    },
    {
      "firstName": "Youssouf",
      "lastName": "COULIBALY",
      "poste": "Président du Pôle Politique",
      "tel": "+223 76 25 60 83",
      "image": "assets/members/youssoufcoulibaly.jpg"
    },
    {
      "firstName": "Kalilou",
      "lastName": "Sofara",
      "poste": "Président du Pôle Maliens établi à l'exterieur / Diaspora",
      "tel": "+223 75 06 12 06",
      "image": "assets/members/sofara.jpg"
    },
    {
      "firstName": "Youba",
      "lastName": "KONATÉ",
      "poste": "Implantation",
      "tel": "+22373 77 77 40",
      "image": "assets/members/youbakonate.jpeg"
    },
    {
      "firstName": "Amadou",
      "lastName": "CISSÉ",
      "poste": "Organisation et mobilisation",
      "tel": "+22376 03 42 47",
      "image": "assets/members/amadou CISSe.jpeg"
    },
    {
      "firstName": "Kankou",
      "lastName": "KEÏTA",
      "poste": "Mobilisation des ressources",
      "tel": "+22366 74 29 93",
      "image": "assets/members/kankoukeita.jpeg"
    },
    {
      "firstName": "Yaya",
      "lastName": "HAÏDARA",
      "poste": "Alliances Stratégiques",
      "tel": "+22366 78 59 47",
      "image": "assets/members/yayahaidara.jpeg"
    },
    {
      "firstName": "Dr Adama",
      "lastName": "Sanogo",
      "poste": "Communication, Information, Évènementiel et TIC",
      "tel": "+223 60 60 60 41",
      "image": "assets/members/adamaadama.jpg"
    },
    {
      "firstName": "Baila",
      "lastName": "NIANG",
      "poste": "Porte-Paroles",
      "tel": "+22373 45 33 00",
      "image": "assets/members/baila niang.jpeg"
    },
    {
      "firstName": "Moriba ",
      "lastName": "SINAYOKO",
      "poste": "Formation et Questions Électorales",
      "tel": "+22376 32 58 51",
      "image": "assets/members/moriba SINAYOKO.jpeg"
    },
    {
      "firstName": "Alassane",
      "lastName": "DIOP",
      "poste": "Questions Juridiques et Contentieux",
      "tel": "+22366 71 65 14",
      "image": "assets/members/alassane diop.jpeg"
    },
    {
      "firstName": "Mamadou",
      "lastName": "TANGARA",
      "poste": "Maliens de l'Extérieur / Diaspora",
      "tel": "+22378 78 97 36",
      "image": "assets/members/mamadoutang.jpeg"
    },
    {
      "firstName": "Salifou",
      "lastName": "COULIBALY",
      "poste": "Demandes Sociales",
      "tel": "+22376 43 81 38",
      "image": "assets/members/salifcoulibaly.jpeg"
    },
    {
      "firstName": "Ousmane",
      "lastName": "DIARRA",
      "poste": "Engagement et Promotion de la Jeunesse",
      "tel": "+22376 06 63 64",
      "image": "assets/members/ousmanediarra.jpeg"
    },
    /*  {
      "firstName": "KEÏTA Fatoumata",
      "lastName": "KEÏTA",
      "poste": "Engagement et Promotion de la Femme",
      "tel": "+22375 15 40 94",
      "image": "assets/members/fantakeita.jpeg"
    }, */
    {
      "firstName": "Alhassane",
      "lastName": "BENGALY",
      "poste": "Coordination des Associations et Clubs de Soutien à SMC",
      "tel": "+22374 67 60 25",
      "image": "assets/members/alhassanebengaly.jpeg"
    },
    {
      "firstName": "Noury N’Dyn",
      "lastName": "SANOGO",
      "poste": "Directeur Exécutif",
      "tel": "+22376 74 35 65",
      "image": "assets/members/noury.jpeg"
    },
    {
      "firstName": "Aly",
      "lastName": "guindo",
      "poste": "Demande sociale",
      "tel": "+223",
      "image": "assets/members/guindo.jpeg"
    },
    {
      "firstName": "Mr Abdoul Kader",
      "lastName": "Diallo",
      "poste": "Chef de Cabinet",
      "tel": "+223",
      "image": "assets/members/kader.jpeg"
    },
    {
      "firstName": "Dionke",
      "lastName": "FOFANA",
      "poste": "Directeur de Cabinet",
      "tel": "+22366741636",
      "image": "assets/members/dionkefofana.jpeg"
    }
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
              "Organigramme nominatif de la Coordination Nationale ",
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
                Get.defaultDialog(
                    title: "Code membre",
                    content: TextField(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        obscureText: true),
                    confirm: ElevatedButton(
                        onPressed: () {
                          if (codeController.text == "020421") {
                            _makePhoneCall(e["tel"]);
                            codeController.text = "";
                            Get.back();
                          } else {
                            codeController.text = "";
                            Get.back();
                            Get.snackbar('Alert', "Code erroné",
                                snackPosition: SnackPosition.TOP);
                          }
                        },
                        child: Text("Valider")));
              },
              child: Stack(children: [
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: new LinearGradient(
                          stops: [0.01, 0.01],
                          colors: [Color(0xFFe95022), Colors.white]),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                e["image"],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(100)),
                      ),
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
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        e["poste"],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.call, color: Color(0xFFe95022)),
                      )
                    ],
                  ),
                ),
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
