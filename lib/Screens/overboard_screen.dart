import 'package:benkan_app/Screens/TabsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:get/get.dart';

class OverboardScreen extends StatefulWidget {
  const OverboardScreen({Key? key}) : super(key: key);

  @override
  State<OverboardScreen> createState() => _OverboardScreenState();
}

class _OverboardScreenState extends State<OverboardScreen> {
  final pages = [
    new PageModel(
        color: const Color(0xFF0097A7),
        imageAssetPath: 'assets/01.png',
        title: 'Screen 1',
        body: 'Share your ideas with the team',
        doAnimateImage: true),
    new PageModel(
        color: const Color(0xFF536DFE),
        imageAssetPath: 'assets/02.png',
        title: 'Screen 2',
        body: 'See the increase in productivity & output',
        doAnimateImage: true),
    new PageModel(
        color: const Color(0xFF9B90BC),
        imageAssetPath: 'assets/03.png',
        title: 'Screen 3',
        body: 'Connect with the people from different places',
        doAnimateImage: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          Get.offAll(TabsScreen());
          // WRITE SKIP BUTTON ACTION HERE
        },
        finishCallback: () {
          Get.offAll(TabsScreen());
          // WRITE THE FINISH BUTTON ACTION HERE
        },
      ),
    );
  }
}
