import 'package:benkan_app/Screens/Admin/commune_hors_bamako.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

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
          _buildMenuItem(
              text: "Les communes de plus de 20 000 électeurs hors Bamako",
              screen: CommuneHorsBamako()),
          _buildMenuItem(
              text:
                  "Liste des Députés de la 6ème législature correspondant aux cercles dont les communes de +20 000 électeurs"),
        ],
      )),
    );
  }

  _buildMenuItem({required String text, screen}) {
    return GestureDetector(
      onTap: () {
        Get.to(screen);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), border: Border.all()),
        child: Text(
          "${text}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
