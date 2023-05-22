import 'package:benkan_app/Screens/TabsScreen.dart';
import 'package:benkan_app/Screens/avis_com_screen.dart';
import 'package:benkan_app/Screens/home_screen.dart';
import 'package:benkan_app/Screens/overboard_screen.dart';
import 'package:benkan_app/Screens/posts_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotif();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Color(0xFFe95022),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
          ),
          primaryColor: Color(0xFFe95022),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Color(0xFFe95022),
          )),
          scaffoldBackgroundColor: Color(0xFFf2f2f2),
          appBarTheme: AppBarTheme(
              centerTitle: true,
              iconTheme: IconThemeData(color: Color(0xFFe95022)),
              actionsIconTheme: IconThemeData(color: Color(0xFFe95022)),
              titleTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              backgroundColor: Color(0xFFf2f2f2),
              elevation: 0.4)),
      title: 'Material App',
      home: TabsScreen(),
    );
  }
}
