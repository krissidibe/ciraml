import 'package:benkan_app/Screens/avis_com_screen.dart';
import 'package:benkan_app/Screens/organigramme_screen.dart';
import 'package:benkan_app/Screens/posts_screen.dart';
import 'package:benkan_app/Screens/profile_screen.dart';
import 'package:benkan_app/Screens/subscribe_benkan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _indexTab = 0;
  List _tabsList = [
    PostsScreen(),
    AvisComScreen(),
    OrganigrammeScreen(),
    SubscribeBenkanScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabsList.elementAt(_indexTab),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 239, 239, 239),
        selectedItemColor: Color(0xFFe95022),
        unselectedItemColor: Colors.grey,
        currentIndex: _indexTab,
        onTap: (i) {
          setState(() {
            _indexTab = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), label: "Actu"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.news_solid), label: "Communiqué"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_3_fill), label: "Organigramme"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_badge_plus_fill),
              label: "Adhérez"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_alt), label: "Profile"),
        ],
      ),
    );
  }
}
