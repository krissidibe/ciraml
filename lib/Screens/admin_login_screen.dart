import 'package:benkan_app/Screens/Admin/admin_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  String typeDefault = "---";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Espace d'aministration"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "assets/logoo.png",
                  scale: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                BuildDropBtn(),
                SizedBox(
                  height: 20,
                ),
                BuildTextField(label: Text("identifiant")),
                SizedBox(
                  height: 20,
                ),
                BuildTextField(label: Text("Mot de passe")),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text("Mot de passe oublié",
                        style:
                            TextStyle(decoration: TextDecoration.underline))),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(AdminHomeScreen());
                    },
                    child: Text("Connexion", style: TextStyle(fontSize: 17)),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                )
              ]),
        ),
      )),
    );
  }

  TextField BuildTextField({label}) {
    return TextField(
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
          color: Color(0xFFe95022),
        ),
        label: label,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.2),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.2),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  SizedBox BuildDropBtn() {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton(
        dropdownColor: Colors.white,
        icon: Container(),
        hint: Text("Votre Region"),
        onChanged: (String? newValue) {
          setState(() {
            typeDefault = newValue!;
          });
        },
        value: typeDefault,
        items: ["---", "Regionnal", "Cercle", "Communal", "Base"]
            .map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }
}
