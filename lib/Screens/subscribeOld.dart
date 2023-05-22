import 'dart:convert';
import 'dart:io';

import 'package:benkan_app/Models/CercleModel.dart';
import 'package:benkan_app/Models/RegionModel.dart';
import 'package:benkan_app/Services/api.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:benkan_app/Services/photo_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';

class SubscribeBenkanScreen extends StatefulWidget {
  const SubscribeBenkanScreen({Key? key}) : super(key: key);

  @override
  _SubscribeBenkanScreenState createState() => _SubscribeBenkanScreenState();
}

class _SubscribeBenkanScreenState extends State<SubscribeBenkanScreen> {
  String _ninaCheck = "";
  String contryExterne = "";
  String _carteElecteurCheck = "";
  File? _imagePath;
  String? orgPolitiqueCheck;
  String? errorMessageNumber;
  String? errorMessageEmail;
  bool isLoading = false;
  TextEditingController orgPolitiqueController = TextEditingController();

  bool skipCercle = false;
  void backAction() {
    setState(() {
      if (_indexQuestion == 0) {
        return;
      }
      _indexQuestion -= 1;
    });
  }

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int _indexQuestion = 0;
  List listQuestions = [
    {"name": "Nom", "type": "input"},
    {"name": "Prénom", "type": "input"},
    {
      "name":
          "Avez-vous été actif dans une organisation politique ou apolitique?",
      "type": "yesNoInput"
    },
    {"name": "Avez-vous une carte NINA", "type": "yesNoInput"},
    {"name": "Avez-vous une carte d'électeur?", "type": "yesNo"},
    {"name": "Votre Numéro de téléphone", "type": "input"},
    {
      "name": "Votre email / le cas échéant un email de contact?",
      "type": "input"
    },
    {"name": "Votre Région", "type": "select"},
    {"name": "Votre Cercle", "type": "select"},
    {"name": "Votre adresse physique?", "type": "input"},
    {"name": "Photo", "type": "photo"},
    {"name": "Genre", "type": "select"},
    {"name": "", "type": ""}
  ];

  String regionDefault = '---';
  String genreDefault = '---';
  String cercleDefault = '---';
  String countryDefault = 'Mali';

  late List<String> _listRegions = [
    "---",
  ];
  late List<String> _listCercle = [
    "---",
  ];
  late List<String> _listGenre = [
    "---",
    "HOMME",
    "FEMME",
  ];
  @override
  void initState() {
    // TODO: implement initState

    HttpService.fetchAllRegions().then((List<Region> datas) {
      datas.forEach((Region item) => _listRegions.add(item.nom));
    });
  }

  @override
  Widget build(BuildContext context) {
    var checkInput = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logoo.png",
          scale: 16,
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Slider(
                      inactiveColor: Colors.black,
                      activeColor: Color(0xFFe95022),
                      min: 0,
                      max: double.parse(listQuestions.length.toString()),
                      value: double.parse(_indexQuestion.toString()),
                      onChanged: (newValue) {}),
                  if (listQuestions[_indexQuestion]["name"] != "Photo")
                    SizedBox(
                      height: 50,
                    ),
                  if (listQuestions[_indexQuestion]["name"] != "Photo")
                    Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.2)),
                      child: Text(listQuestions[_indexQuestion]["name"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  SizedBox(
                    height: 50,
                  ),
                  if (_indexQuestion != listQuestions.length - 1)
                    if (orgPolitiqueCheck == "Oui" && _indexQuestion == 2)
                      TextField(
                        controller: orgPolitiqueController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.2),
                              borderRadius: BorderRadius.circular(0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.2),
                              borderRadius: BorderRadius.circular(0)),
                        ),
                      ),
                  if (listQuestions[_indexQuestion]["type"] == "photo")
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            image: (_imagePath != null)
                                ? DecorationImage(image: FileImage(_imagePath!))
                                : null,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                            width: 200,
                            child: BuildBtn(
                                label: "Camera",
                                action: () {
                                  onImageCropBtnClick(
                                          source: ImageSource.camera)
                                      .then((XFile? data) =>
                                          cropImage(file: data!.path)
                                              .then((value) {
                                            setState(() {
                                              _imagePath = value;
                                            });
                                          }));
                                })),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: 200,
                            child: BuildBtn(
                                color: Colors.orange,
                                label: "Gallerie",
                                action: () {
                                  onImageCropBtnClick(
                                          source: ImageSource.gallery)
                                      .then((XFile? data) =>
                                          cropImage(file: data!.path)
                                              .then((value) {
                                            setState(() {
                                              _imagePath = value;
                                            });
                                          }));
                                }))
                      ],
                    ),
                  if (listQuestions[_indexQuestion]["type"] == "input")
                    TextField(
                      controller: controllers[_indexQuestion],
                      onChanged: (String v) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.2),
                            borderRadius: BorderRadius.circular(0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.2),
                            borderRadius: BorderRadius.circular(0)),
                      ),
                    )
                  else if (listQuestions[_indexQuestion]["type"] == "yesNo")
                    Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BuildBtnYesNo(
                              valueChanged: [_ninaCheck, _carteElecteurCheck],
                              action: () {
                                if (_indexQuestion == 3) {
                                  setState(() {
                                    _ninaCheck = "Non";
                                  });
                                } else if (_indexQuestion == 4) {
                                  setState(() {
                                    _carteElecteurCheck = "Non";
                                  });
                                }
                              },
                              color: (_indexQuestion == 3)
                                  ? (_ninaCheck == "Non")
                                      ? Colors.orange
                                      : Colors.black
                                  : (_carteElecteurCheck == "Non")
                                      ? Colors.orange
                                      : Colors.black,
                              label: "Non"),
                          SizedBox(
                            width: 20,
                          ),
                          BuildBtnYesNo(
                              valueChanged: [_ninaCheck, _carteElecteurCheck],
                              action: () {
                                if (_indexQuestion == 3) {
                                  setState(() {
                                    _ninaCheck = "Oui";
                                  });
                                } else if (_indexQuestion == 4) {
                                  setState(() {
                                    _carteElecteurCheck = "Oui";
                                  });
                                }
                              },
                              color: (_indexQuestion == 3)
                                  ? (_ninaCheck == "Oui")
                                      ? Colors.orange
                                      : Colors.black
                                  : (_carteElecteurCheck == "Oui")
                                      ? Colors.orange
                                      : Colors.black,
                              label: "Oui"),
                        ],
                      ),
                    ),
                  if (listQuestions[_indexQuestion]["type"] == "yesNoInput")
                    Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BuildBtnYesNo(
                              valueChanged: orgPolitiqueCheck,
                              action: () {
                                setState(() {
                                  orgPolitiqueCheck = "Non";
                                });
                              },
                              color: (orgPolitiqueCheck == "Non")
                                  ? Colors.orange
                                  : Colors.black,
                              label: "Non"),
                          SizedBox(
                            width: 20,
                          ),
                          BuildBtnYesNo(
                              valueChanged: orgPolitiqueCheck,
                              action: () {
                                setState(() {
                                  orgPolitiqueCheck = "Oui";
                                });
                              },
                              color: (orgPolitiqueCheck == "Oui")
                                  ? Colors.orange
                                  : Colors.black,
                              label: "Oui"),
                        ],
                      ),
                    ),
                  if (listQuestions[_indexQuestion]["type"] == "select" &&
                      _indexQuestion == 11)
                    BuildDropGenre(),
                  if (listQuestions[_indexQuestion]["type"] == "select" &&
                      _indexQuestion == 7)
                    BuildDropBtn(),
                  if (listQuestions[_indexQuestion]["type"] == "select" &&
                      _indexQuestion == 8 &&
                      skipCercle == false)
                    FutureBuilder(
                      future: HttpService.fetchAllCercle(value: regionDefault),
                      builder: (context, AsyncSnapshot<List<Cercle>> snapshot) {
                        if (snapshot.hasData) {
                          return BuildDropBtnCercle();
                        }
                        return Center(
                            child: CircularProgressIndicator(
                          color: Color(0xFFe95022),
                        ));
                      },
                    ),
                  if (listQuestions[_indexQuestion]["type"] == "select" &&
                      _indexQuestion == 8 &&
                      skipCercle == true)
                    Center(
                        child: Text(
                            "Pas de cercle pour les autres Pays Cliquez sur Suivant")),
                  if (_indexQuestion == 9)
                    FutureBuilder(
                      future: HttpService.verificationCheck(
                          endpoint: Api.checkNumber,
                          value: controllers[5].text),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == true) {
                            errorMessageNumber =
                                "Ce numero de telephone existe veuillez choisir un autre";

                            return Container();
                          }
                          if (snapshot.data == false) {
                            errorMessageNumber = "";
                            return Container();
                          }
                        }
                        return Container();
                      },
                    ),
                  if (_indexQuestion == 9)
                    FutureBuilder(
                      future: HttpService.verificationCheck(
                          endpoint: Api.checkEmail, value: controllers[6].text),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == true) {
                            errorMessageEmail =
                                "votre email existe veuillez choisir un autre";

                            return Container();
                          }
                          if (snapshot.data == false) {
                            errorMessageEmail = "";
                            return Container();
                          }
                        }
                        return Container();
                      },
                    ),
                  if (_indexQuestion > 9)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        (errorMessageNumber != null)
                            ? Text(errorMessageNumber!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red))
                            : Container(),
                        (errorMessageEmail != null)
                            ? Text(errorMessageEmail!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red))
                            : Container(),
                      ],
                    ),
                  if (isLoading == true)
                    Center(child: Text("Envoie en cours...")),
                  Container()
                ],
              ),
            ),
          )),
          if (!checkInput && isLoading == false)
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: BuildBtn(
                          action: () {
                            setState(() {
                              if (_indexQuestion == 0) {
                                return;
                              }
                              _indexQuestion -= 1;
                            });
                          },
                          color: Colors.black,
                          label: "Précedent"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    (_indexQuestion != listQuestions.length - 1)
                        ? Expanded(
                            child: (controllers[_indexQuestion].text != "" ||
                                    (_indexQuestion == 2 &&
                                        orgPolitiqueCheck != null) ||
                                    (_indexQuestion == 3 && _ninaCheck != "") ||
                                    (_indexQuestion == 4 &&
                                        _carteElecteurCheck != "") ||
                                    (_indexQuestion == 7 &&
                                            regionDefault != "---" ||
                                        skipCercle == true) ||
                                    (_indexQuestion == 8 &&
                                        cercleDefault != "---") ||
                                    (_indexQuestion == 10 &&
                                        _imagePath != null) ||
                                    (_indexQuestion == 11 &&
                                        regionDefault != "---"))
                                ? BuildBtn(
                                    action: () {
                                      print(listQuestions.length);
                                      print(errorMessageNumber);
                                      print(errorMessageEmail);
                                      setState(() {
                                        if (_indexQuestion ==
                                            listQuestions.length - 1) {
                                          return;
                                        }
                                        _indexQuestion += 1;
                                      });
                                    },
                                    label: "Suivant")
                                : Container(),
                          )
                        : Expanded(
                            child: (_indexQuestion == 12 &&
                                    _imagePath != null &&
                                    (_indexQuestion > 8 &&
                                        errorMessageNumber == "" &&
                                        errorMessageEmail == "") &&
                                    isLoading == false)
                                ? BuildBtn(
                                    color: Colors.teal,
                                    action: () {
                                      if (skipCercle) {
                                        regionDefault = contryExterne;
                                        cercleDefault = contryExterne;
                                      }
                                      var datas = {
                                        "nom": controllers[0].text,
                                        "prenom": controllers[1].text,
                                        "inOrganisation":
                                            (orgPolitiqueCheck == "Non")
                                                ? orgPolitiqueCheck
                                                : orgPolitiqueController.text,
                                        "nina": _ninaCheck,
                                        "carteElec": _carteElecteurCheck,
                                        "numero": controllers[5].text,
                                        "email": controllers[6].text,
                                        "region": regionDefault,
                                        "cercleComune": cercleDefault,
                                        "adresse": controllers[9].text,
                                        "photo": _imagePath,
                                        "genre": genreDefault,
                                      };
                                      var datasFake = {
                                        "nom": "Kris",
                                        "prenom": "Kris",
                                        "inOrganisation": "Kris",
                                        "nina": "Kris",
                                        "carteElec": "Kris",
                                        "numero": "Kris",
                                        "email": "Kris",
                                        "region": "Kris",
                                        "cercleComune": "Kris",
                                        "adresse": "Kris",
                                        "photo": _imagePath
                                      };

                                      setState(() {
                                        isLoading = true;
                                      });
                                      /*  print(datas);
                                      return; */
                                      HttpService.postAllDatas(datas: datas)
                                          .then(
                                        (value) {
                                          print(value);
                                          if (value == "OK") {
                                            var test = Get.defaultDialog(
                                              title: "Alert",
                                              middleText: "Ajout effectuer",
                                              onConfirm: () {
                                                Get.back();
                                                Get.back();
                                              },
                                            );
                                            test.then((d) {
                                              Get.back();
                                              Get.back();
                                            });
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            var test = Get.defaultDialog(
                                              buttonColor: Colors.teal,
                                              confirmTextColor: Colors.white,
                                              title: "Alert",
                                              middleText:
                                                  "Ajout non effectuer vérifier votre email et numero ainsi les champs.",
                                              onConfirm: () {
                                                Get.back();
                                              },
                                            );
                                          }
                                        },
                                      );
                                    },
                                    label: "Envoyer")
                                : Container(),
                          ),
                    SizedBox(
                      width: 20,
                    ),
                  ]),
            ),
        ]),
      ),
    );
  }

  SizedBox BuildDropGenre() {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton(
        dropdownColor: Colors.white,
        icon: Container(),
        hint: Text("Votre Sexe"),
        onChanged: (String? newValue) {
          print(newValue);
          setState(() {
            genreDefault = newValue!;
          });
        },
        value: genreDefault,
        items: _listGenre.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }

  BuildDropBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: DropdownButton(
              dropdownColor: Colors.white,
              icon: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  countryDefault = newValue!;
                  skipCercle = false;
                  contryExterne = "";
                  regionDefault = "---";
                });
              },
              value: countryDefault,
              items: ["Mali", "Autre"]
                  .map((String e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList()),
        ),
        SizedBox(
          height: 10,
        ),
        if (countryDefault == "Mali")
          SizedBox(
            width: double.infinity,
            child: DropdownButton(
              dropdownColor: Colors.white,
              icon: Container(),
              hint: Text("Votre Region"),
              onChanged: (String? newValue) {
                setState(() {
                  regionDefault = newValue!;
                  skipCercle = false;
                  cercleDefault = "---";
                  _listCercle.clear();
                  _listCercle.add(cercleDefault);
                  HttpService.fetchAllCercle(value: regionDefault)
                      .then((List<Cercle> datas) {
                    datas.forEach((Cercle item) => _listCercle.add(item.non));
                    print(_listCercle);
                  });
                });
              },
              value: regionDefault,
              items: _listRegions.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
            ),
          ),
        if (countryDefault == "Autre")
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode:
                      false, // optional. Shows phone code before the country name.
                  onSelect: (Country country) {
                    setState(() {
                      contryExterne = country.name;
                      skipCercle = true;
                    });
                    print('Select country: ${country.name}');
                  },
                );
              },
              child: Text("Veuillez selectionner votre pays"),
            ),
          ),
        SizedBox(
          height: 20,
        ),
        if (countryDefault == "Autre")
          Text(
            "- Pays : ${contryExterne} ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }

  SizedBox BuildDropBtnCercle() {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton(
        dropdownColor: Colors.white,
        icon: Container(),
        hint: Text("Votre Cercle"),
        onChanged: (String? newValueCerlce) {
          setState(() {
            cercleDefault = newValueCerlce!;
          });
        },
        value: cercleDefault,
        items: _listCercle.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }

  SizedBox BuildBtn({color, label, action}) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(elevation: 0, primary: color),
        onPressed: action,
        child: Text(label),
      ),
    );
  }

  SizedBox BuildBtnYesNo({color, label, action, valueChanged}) {
    return SizedBox(
      height: 50,
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(elevation: 0, primary: color),
        onPressed: action,
        child: Text(label),
      ),
    );
  }
}
