import 'dart:io';

import 'package:benkan_app/Models/AvisComModel.dart';
import 'package:benkan_app/Models/PostModel.dart';
import 'package:benkan_app/Screens/avis_detail_screen.dart';
import 'package:benkan_app/Screens/post_detail_screen.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class AvisComScreen extends StatefulWidget {
  const AvisComScreen({Key? key}) : super(key: key);

  @override
  _AvisComScreenState createState() => _AvisComScreenState();
}

class _AvisComScreenState extends State<AvisComScreen> {
  late Future<List<Post>> futureAllPost;
  @override
  void initState() {
    super.initState();
    HttpService.fetchAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/logoo.png",
          scale: 16,
        ),
        actions: [
          /*  Icon(Icons.search), */
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: FutureBuilder(
        future: HttpService.fetchAllAvis(),
        builder: (context, AsyncSnapshot<List<AvisCom>> snapshot) {
          if (snapshot.hasData) {
            List<AvisCom> datas = snapshot.data!;

            return ListView(
              children: datas.map((AvisCom item) => BuildItem(item)).toList(),
            );
          }
          return Center(
              child: CircularProgressIndicator(
            color: Color(0xFFe95022),
          ));
        },
      ),
    );
  }

  GestureDetector BuildItem(AvisCom item) {
    return GestureDetector(
      onTap: () {
        Get.to(AvisDetailScreen(avis: item));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (item.image.length > 5)
                      SizedBox(
                        width: double.infinity,
                        child: Image.network(
                          "https://www.gestion-benkan.ml/images/${item.image}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    Text(
                      item.titre,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                            style: TextButton.styleFrom(primary: Colors.black),
                            onPressed: () async {
                              final url = Uri.parse(
                                  "https://www.gestion-benkan.ml/images/${item.image}");

                              final response = await http.get(url);

                              final bytes = response.bodyBytes;

                              final temp = await getTemporaryDirectory();
                              final path = "${temp.path}/image.jpg";

                              File(path).writeAsBytesSync(bytes);

                              // final xPath = XFile(path, bytes: bytes, name: "Image");

                              if (Platform.isAndroid) {
                                Share.shareFiles(
                                  [path],
                                  text:
                                      "https://play.google.com/store/apps/details?id=com.benkan&hl=fr&gl=US",
                                );
                              } else {
                                Share.shareFiles(
                                  [path],
                                  text:
                                      "https://apps.apple.com/me/app/benkan/id1592340088",
                                );
                              }
                            },
                            icon: Icon(CupertinoIcons.share),
                            label: Text("Partager")),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                    /*  Text(
                      item.contenu,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(fontSize: 15),
                    ), */

                    /*  SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Lire"),
                        style: ElevatedButton.styleFrom(),
                      ),
                    ), */
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

/*  ListView.builder(itemCount: futureAllPost,
      itemBuilder: (context,index) => BuildCard(item:snapshot.data!),
      ) */
  BuildCard({image, titre, updated_at, contenu}) => GestureDetector(
        child: Hero(
          tag: "tag",
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Card(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titre,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          updated_at,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          contenu,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("Lire"),
                            style: ElevatedButton.styleFrom(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ),
        ),
      );
}
