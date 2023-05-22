import 'package:benkan_app/Screens/admin_login_screen.dart';
import 'package:benkan_app/Screens/avis_com_screen.dart';
import 'package:benkan_app/Screens/boite_outils_screen.dart';
import 'package:benkan_app/Screens/organigramme_screen.dart';
import 'package:benkan_app/Screens/personnes_ressource_screen.dart';
import 'package:benkan_app/Screens/posts_screen.dart';
import 'package:benkan_app/Screens/subscribe_benkan_screen.dart';
import 'package:benkan_app/Screens/video_com_screen.dart';
import 'package:benkan_app/Services/api.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController codeController = TextEditingController();
  Future initNotif() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    AndroidNotificationChannel channel = new AndroidNotificationChannel(
        "id", "name",
        description: "Description");
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp =========");
      print(message.notification!.title.toString().toLowerCase());
      if (message.notification!.title
          .toString()
          .toLowerCase()
          .contains("avis")) {
        Get.to(AvisComScreen());
      } else {
        Get.to(PostsScreen());
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        return;
      }
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initNotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(AdminLoginScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("Espace d'aministration")),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
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
                child: Image.asset(
                  "assets/logoo.png",
                  scale: 5,
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text("Bienvenue sur Benkan",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))),
              Center(
                child: Wrap(
                  spacing: 5,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.start,
                  children: [
                    BuildCard(context,
                        title: "Actu Benkan",
                        image: "assets/icons/news.png",
                        screen: PostsScreen()),
                    BuildCard(context,
                        title: "Avis & Communiqué",
                        image: "assets/icons/avis.png",
                        screen: AvisComScreen()),
                    BuildCard(context,
                        title: "Adhérez Benkan",
                        image: "assets/icons/admin.png",
                        screen: SubscribeBenkanScreen()),
                    BuildCard(context,
                        title: "Organigramme de Benkan",
                        image: "assets/icons/organigramme.jpeg",
                        screen: OrganigrammeScreen()),
                    /* BuildCard(
                      context,
                      title: "Benkan video",
                      image: "assets/icons/video.png",
                      size: 60.0,
                      screen: VideoBenkaScreen(),
                    ), */

                    BuildCard2(context,
                        title: "Nous Contacter",
                        image: "assets/icons/call.png",
                        screen: PostsScreen()),
                    GestureDetector(
                      onTap: () {
                        Get.to(BoiteOutilsScreen());
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 175,
                        width: (MediaQuery.of(context).size.width / 2) -
                            MediaQuery.of(context).size.width * 0.08,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 0.2)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              MdiIcons.viewDashboard,
                              size: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Boite à outils",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BuildCard(context, {title, image, screen, size}) {
    return GestureDetector(
      onTap: () {
        Get.to(screen);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 175,
        width: (MediaQuery.of(context).size.width / 2) -
            MediaQuery.of(context).size.width * 0.08,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 0.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              image,
              scale: 2.5,
              width: size,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  BuildCard2(
    context, {
    title,
    image,
    screen,
  }) {
    return GestureDetector(
      onTap: () {
        _makePhoneCall("0022397979709");
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 175,
        width: (MediaQuery.of(context).size.width / 2) -
            MediaQuery.of(context).size.width * 0.08,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 0.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              image,
              scale: 2.5,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
