import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:benkan_app/Models/PostModel.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CommuneHorsBamako extends StatefulWidget {
  const CommuneHorsBamako({
    Key? key,
  }) : super(key: key);

  @override
  State<CommuneHorsBamako> createState() => _CommuneHorsBamakoState();
}

class _CommuneHorsBamakoState extends State<CommuneHorsBamako> {
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
      "cercle": "Sikasso",
      "communes": [
        {
          "name": "Sikasso",
          "maire": "Kalifa Sanogo (Adéma)",
          "electeursNombre": "135883",
          "tel": "66 54 11 07"
        },
      ]
    },
    {
      "cercle": "kati",
      "communes": [
        {
          "name": "Kalabankoro",
          "electeursNombre": "99516",
          "maire": "Issa Bocar Ballo(CNID),Tièkoura Amadoun Diarra (RPM)",
          "tel": "66 43 79 64"
        },
        {
          "name": "Kati",
          "electeursNombre": "60180",
          "maire": "Yoro Wologueme (URD) ",
          "tel": "79 32 48 64"
        },
        {
          "name": "Mandé",
          "electeursNombre": "30245",
          "maire": "Nouhoum Kelepily (UDD)",
          "tel": "73 05 86 11"
        },
        {
          "name": "Dialakorodji",
          "electeursNombre": "27682",
          "maire": "Oumar Guindo (RPM)(CODEM)",
          "tel": "79 40 03 30"
        },
        {
          "name": "Sangarebougou",
          "electeursNombre": "27665",
          "maire": "Kassoum Sidibé (URD)",
          "tel": "76 48 99 73"
        }
      ]
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
              "Les communes de plus de 20 000 électeurs hors Bamako",
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
            (e) => _buildItemCard(e),
          ),
          SizedBox(
            height: 50,
          )
        ],
      )),
    );
  }

  GestureDetector _buildItemCard(e) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.white,
            context: context,
            builder: ((context) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                              "Cercle de ${e["cercle"]}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close),
                          )
                        ],
                      ),
                      Divider(),
                      ...e["communes"].map((item) => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Get.defaultDialog(
                                  title: "",
                                  titleStyle: TextStyle(fontSize: 0),
                                  textConfirm: "Appelez",
                                  confirmTextColor: Colors.white,
                                  textCancel: "retour",
                                  onCancel: () {},
                                  onConfirm: () {
                                    _makePhoneCall(item["tel"]);
                                  },
                                  titlePadding: EdgeInsets.all(0),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person, size: 35),
                                      SizedBox(height: 5),
                                      Text(item["maire"],
                                          textAlign: TextAlign.center),
                                      SizedBox(height: 5),
                                      Text(item["tel"])
                                    ],
                                  ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        item["electeursNombre"],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )),
                                  Icon(Icons.arrow_forward_ios_sharp)
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                )));

        return;
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: new LinearGradient(
                stops: [0.01, 0.01], colors: [Color(0xFFe95022), Colors.white]),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          "${e['cercle']}",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
