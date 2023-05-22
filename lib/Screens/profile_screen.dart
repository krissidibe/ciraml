import 'package:benkan_app/Screens/personnes_ressource_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Admin/admin_home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
  @override
  Widget build(BuildContext context) {
    var count = 0.obs;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onLongPress: () {
                  Get.defaultDialog(
                      title: "Code membre",
                      content: TextField(
                          controller: codeController,
                          keyboardType: TextInputType.number,
                          obscureText: true),
                      confirm: ElevatedButton(
                          onPressed: () {
                            if (codeController.text == "020421") {
                              Get.back();
                              Future.delayed(Duration(seconds: 1), () {
                                Get.to(AdminHomeScreen());
                              });

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
                onDoubleTap: () {
                  Get.defaultDialog(
                      title: "Code membre",
                      content: TextField(
                          controller: codeController,
                          keyboardType: TextInputType.number,
                          obscureText: true),
                      confirm: ElevatedButton(
                          onPressed: () {
                            if (codeController.text == "020421") {
                              Get.back();
                              Future.delayed(Duration(seconds: 1), () {
                                Get.to(PersonnesRessourceScreen());
                              });

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
                child: Container(
                  width: double.infinity,
                  child: Image.asset(
                    "assets/logoo.png",
                    scale: 5,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  print("object");
                  _makePhoneCall("0022397979709");
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 0.2)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Nous Contacter",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
              /*   
              SizedBox(
                height: 40,
              ),
              /*    InputFloat(context, label: "Numero de téléphone ou email"),
              InputFloat(context, label: "Mot de passe"), */
              SizedBox(
                height: 20,
              ),
                 SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Connexion",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ))) */
            ],
          ),
        ),
      ),
    );
  }

  Container InputFloat(BuildContext context, {label}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        decoration: InputDecoration(
            label: Text("${label}"),
            floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 18),
            focusColor: Theme.of(context).primaryColor,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
      ),
    );
  }
}
