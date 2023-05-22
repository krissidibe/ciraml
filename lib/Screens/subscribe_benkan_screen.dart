import 'dart:convert';
import 'dart:io';

import 'package:benkan_app/Screens/TabsScreen.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'package:benkan_app/Models/CercleModel.dart';
import 'package:benkan_app/Models/RegionModel.dart';
import 'package:benkan_app/Services/api.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:benkan_app/Services/photo_service.dart';
import 'package:path_provider/path_provider.dart';

class QcmModel {
  final String name;
  final String type;
  final TextEditingController controller;
  bool? canNext;
  bool? yesNoCheck;
  QcmModel({
    required this.name,
    required this.type,
    required this.controller,
    this.canNext,
    this.yesNoCheck,
  });
}

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
  String? ninaCheck;
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

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController organisationController = TextEditingController();
  TextEditingController ninaController = TextEditingController();
  TextEditingController carteBioController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController cercleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  int _indexQuestion = 0;

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

  late List<QcmModel> listQuestions;
  @override
  void initState() {
    // TODO: implement initState

    HttpService.fetchAllRegions().then((List<Region> datas) {
      datas.forEach((Region item) => _listRegions.add(item.nom));
    });

    listQuestions = [
      QcmModel(
          name: "Nom",
          controller: lastNameController,
          type: "input",
          canNext: false),
      QcmModel(
          name: "Prénom",
          controller: firstNameController,
          type: "input",
          canNext: false),
      QcmModel(
          name:
              "Avez-vous été actif dans une organisation politique ou apolitique?",
          controller: organisationController,
          type: "yesNoInput",
          yesNoCheck: false,
          canNext: false),
      QcmModel(
          name: "Avez-vous une carte NINA ?",
          controller: ninaController,
          type: "yesNoInput",
          yesNoCheck: false,
          canNext: false),
      QcmModel(
          name: "Avez-vous une carte biométrique ?",
          controller: carteBioController,
          type: "yesNo",
          yesNoCheck: false,
          canNext: false),
      QcmModel(
          name: "Votre Numéro de téléphone",
          controller: numberController,
          type: "input",
          canNext: false),
      QcmModel(
          name: "Votre email / le cas échéant un email de contact?",
          controller: emailController,
          type: "input",
          canNext: true),
      QcmModel(
          name: "Votre Région",
          controller: regionController,
          type: "selectCountry",
          canNext: false),
      QcmModel(
          name: "Votre Cercle",
          controller: cercleController,
          type: "selectCercle",
          canNext: false),
      QcmModel(
          name: "Votre adresse physique?",
          controller: adressController,
          type: "input",
          canNext: false),
      QcmModel(
          name: "Votre Genre",
          controller: genreController,
          type: "selectGenre",
          canNext: false),
      QcmModel(
          name: "Photo",
          controller: photoController,
          type: "photo",
          canNext: false),
      QcmModel(
          name: "Envoyer les données",
          controller: photoController,
          type: "final",
          canNext: true),
    ];
  }

  renderQcmState(QcmModel qcmModel) {
    switch (qcmModel.type) {
      case "input":
        return TextField(
          controller: qcmModel.controller,
          onChanged: (v) {
            if (v.length >= 3) {
              setState(() {
                qcmModel.canNext = true;
              });
            } else {
              setState(() {
                qcmModel.canNext = false;
              });
            }

            // print(qcmModel.canNext);
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
        );

      case "yesNo":
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BuildBtnYesNo(
                    valueChanged: qcmModel.yesNoCheck,
                    action: () {
                      setState(() {
                        qcmModel.yesNoCheck = false;
                        qcmModel.controller.text = "Non";
                        qcmModel.canNext = true;
                      });
                    },
                    color: (qcmModel.yesNoCheck == false &&
                            qcmModel.controller.text == "Non")
                        ? Colors.orange
                        : Colors.black,
                    label: "Non"),
                SizedBox(
                  width: 20,
                ),
                BuildBtnYesNo(
                    valueChanged: qcmModel.yesNoCheck,
                    action: () {
                      setState(() {
                        qcmModel.yesNoCheck = true;
                        qcmModel.canNext = true;
                        qcmModel.controller.text = "Oui";
                      });
                    },
                    color: (qcmModel.yesNoCheck == true)
                        ? Colors.orange
                        : Colors.black,
                    label: "Oui"),
              ],
            ),
          ],
        );
      case "yesNoInput":
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BuildBtnYesNo(
                    valueChanged: qcmModel.yesNoCheck,
                    action: () {
                      setState(() {
                        qcmModel.yesNoCheck = false;
                        qcmModel.controller.text = "Non";
                        qcmModel.canNext = true;
                      });
                    },
                    color: (qcmModel.yesNoCheck == false &&
                            qcmModel.controller.text == "Non")
                        ? Colors.orange
                        : Colors.black,
                    label: "Non"),
                SizedBox(
                  width: 20,
                ),
                BuildBtnYesNo(
                    valueChanged: qcmModel.yesNoCheck,
                    action: () {
                      setState(() {
                        qcmModel.yesNoCheck = true;
                        qcmModel.canNext = false;
                        qcmModel.controller.text = "";
                      });
                    },
                    color: (qcmModel.yesNoCheck == true)
                        ? Colors.orange
                        : Colors.black,
                    label: "Oui"),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            if (qcmModel.name.contains("NINA") && qcmModel.yesNoCheck == true)
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Numero nina :",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )),
            if (qcmModel.name.contains("NINA") && qcmModel.yesNoCheck == true)
              SizedBox(
                height: 10,
              ),
            if (qcmModel.yesNoCheck == true)
              TextField(
                controller: qcmModel.controller,
                onChanged: (v) {
                  if (v.length >= 3) {
                    setState(() {
                      qcmModel.canNext = true;
                    });
                  } else {
                    setState(() {
                      qcmModel.canNext = false;
                    });
                  }
                  print(qcmModel.canNext);
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
          ],
        );
      case "selectCountry":
        return BuildDropBtn(qcmModel);
      case "selectCercle":
        if (skipCercle) {
          qcmModel.canNext = true;
        }
        return Column(
          children: [
            if (skipCercle == false)
              FutureBuilder(
                future: HttpService.fetchAllCercle(value: regionDefault),
                builder: (context, AsyncSnapshot<List<Cercle>> snapshot) {
                  if (snapshot.hasData) {
                    return BuildDropBtnCercle(qcmModel);
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFFe95022),
                  ));
                },
              ),
            if (skipCercle == true)
              Center(
                  child: Text(
                      "Pas de cercle pour les autres Pays Cliquez sur Suivant")),
          ],
        );
      //  return BuildDropBtnCercle(qcmModel);
      case "selectGenre":
        return BuildDropGenre(qcmModel);
      case "photo":
        return Column(
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
                      onImageCropBtnClick(source: ImageSource.camera).then(
                          (XFile? data) =>
                              cropImage(file: data!.path).then((value) {
                                setState(() {
                                  _imagePath = value;
                                  qcmModel.canNext = true;
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
                      onImageCropBtnClick(source: ImageSource.gallery).then(
                          (XFile? data) =>
                              cropImage(file: data!.path).then((value) {
                                setState(() {
                                  _imagePath = value;
                                  qcmModel.canNext = true;
                                });
                              }));
                    })),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                width: 200,
                child: BuildBtn(
                    color: Colors.black,
                    label: "Sans photo",
                    action: () async {
                      final pathLogo = "logoo.png";

                      final byteData =
                          await rootBundle.load('assets/$pathLogo');
                      final buffer = byteData.buffer;
                      Directory tempDir = await getTemporaryDirectory();
                      String tempPath = tempDir.path;
                      var filePath = tempPath +
                          '/file_01.tmp'; // file_01.tmp is dump file, can be anything
                      final fileFinal = File(filePath).writeAsBytes(
                          buffer.asUint8List(
                              byteData.offsetInBytes, byteData.lengthInBytes));

                      setState(() {
                        _imagePath = File(filePath);
                        qcmModel.canNext = true;
                      });
                    }))
          ],
        );
      case "final":
        return Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nom : ${firstNameController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Prénom : ${lastNameController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "organisation : ${organisationController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Nina : ${ninaController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Carte biométrique : ${carteBioController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Téléphone : ${numberController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Email : ${emailController.text.length == 0 ? "N/A" : emailController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Region : ${regionController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Cerlce : ${cercleController.text == "" ? regionController.text : cercleController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Adresse : ${adressController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Genre : ${genreController.text}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        );
      default:
        Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    List listQuestion = [
      {
        "name": "Nom",
        "controller": lastNameController,
        "type": "input",
        "canNext": false
      },
      {
        "name": "Prénom",
        "controller": firstNameController,
        "type": "input",
        "canNext": "val"
      },
      //  {"name": "Nom", "type": "input", "value": "val"},

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

    var checkInput = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logoo.png",
          scale: 16,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Expanded(
              child: Container(
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
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 0.2)),
                        child: Text(listQuestions[_indexQuestion].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //   Text(listQuestions[_indexQuestion].type)

                      renderQcmState(listQuestions[_indexQuestion])
                    ],
                  ),
                ),
              ),
            ),
            if (!isLoading)
              Row(
                children: [
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
                  Expanded(
                    child: (listQuestions[_indexQuestion].canNext == true)
                        ? BuildBtn(
                            action: () {
                              if (listQuestions[_indexQuestion]
                                  .name
                                  .contains("Numéro")) {
                                HttpService.verificationCheck(
                                        endpoint: Api.checkNumber,
                                        value: numberController.text)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      _indexQuestion = 5;
                                    });
                                    Get.defaultDialog(
                                        middleText:
                                            "Ce numéro de téléphone existe déjà. Veuillez choisir un autre");
                                  }
                                  print("number verify : ${value}");
                                });
                              }

                              if (_indexQuestion + 1 == listQuestions.length &&
                                  listQuestions[_indexQuestion].canNext ==
                                      true) {
                                setState(() {
                                  listQuestions[_indexQuestion].canNext = false;
                                });
                                if (skipCercle) {
                                  regionDefault = contryExterne;
                                  cercleDefault = contryExterne;
                                }

                                HttpService.verificationCheck(
                                        endpoint: Api.checkNumber,
                                        value: numberController.text)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      _indexQuestion = 5;
                                    });
                                    Get.defaultDialog(
                                        middleText:
                                            "Ce numero de telephone existe veuillez choisir un autre");
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    var datas = {
                                      "nom": lastNameController.text.trim(),
                                      "prenom": firstNameController.text.trim(),
                                      "inOrganisation": (orgPolitiqueCheck ==
                                              "Non")
                                          ? orgPolitiqueCheck
                                          : organisationController.text.trim(),
                                      "nina": ninaController.text.trim(),
                                      "carteElec":
                                          carteBioController.text.trim(),
                                      "numero": numberController.text.trim(),
                                      "email":
                                          emailController.text.trim().length ==
                                                  0
                                              ? "N/A"
                                              : emailController.text.trim(),
                                      "region": regionDefault,
                                      "cercleComune": cercleDefault,
                                      "adresse": adressController.text.trim(),
                                      "photo": _imagePath,
                                      "genre": genreController.text.trim(),
                                    };

                                    HttpService.postAllDatas(datas: datas)
                                        .then((value) {
                                      print(value);
                                      if (value == "OK") {
                                        var test = Get.defaultDialog(
                                          title: "Alert",
                                          middleText: "Ajout effectuer",
                                          onConfirm: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TabsScreen()),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                        );
                                        test.then((d) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TabsScreen()),
                                            (Route<dynamic> route) => false,
                                          );
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
                                            setState(() {
                                              listQuestions[_indexQuestion]
                                                  .canNext = true;
                                            });
                                          },
                                        );
                                      }
                                    });
                                  }
                                });
                              }
                              setState(() {
                                if (_indexQuestion + 1 >=
                                    listQuestions.length) {
                                  return;
                                }
                                _indexQuestion += 1;
                              });
                            },
                            color: _indexQuestion + 1 == listQuestions.length
                                ? Color.fromARGB(255, 2, 143, 151)
                                : Color(0xFFe95022),
                            label:
                                "${_indexQuestion + 1 == listQuestions.length ? "Terminer" : "Suivant"} ")
                        : Container(),
                  ),
                ],
              ),
          ]),
        ),
      ),
    );
  }

  SizedBox BuildDropGenre(QcmModel qcmModel) {
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
            qcmModel.controller.text = newValue;
            if (newValue != "---") {
              qcmModel.canNext = true;
            } else {
              qcmModel.canNext = false;
            }
          });
        },
        value: genreDefault,
        items: _listGenre.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }

  BuildDropBtn(QcmModel qcmModel) {
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
                  qcmModel.controller.text = newValue;
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
                  if (newValue != "---") {
                    qcmModel.controller.text = newValue;
                    qcmModel.canNext = true;
                    HttpService.fetchAllCercle(value: regionDefault)
                        .then((List<Cercle> datas) {
                      datas.forEach((Cercle item) => _listCercle.add(item.non));
                      print(_listCercle);
                    });
                  } else {
                    qcmModel.canNext = false;
                  }
                  cercleDefault = "---";
                  _listCercle.clear();
                  _listCercle.add(cercleDefault);
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
                      qcmModel.controller.text = country.name;
                      qcmModel.canNext = true;
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

  SizedBox BuildDropBtnCercle(QcmModel qcmModel) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton(
        dropdownColor: Colors.white,
        icon: Container(),
        hint: Text("Votre Cercle"),
        onChanged: (String? newValueCerlce) {
          setState(() {
            cercleDefault = newValueCerlce!;
            if (newValueCerlce != "---") {
              qcmModel.controller.text = newValueCerlce;
              qcmModel.canNext = true;
            } else {
              qcmModel.canNext = false;
            }
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
