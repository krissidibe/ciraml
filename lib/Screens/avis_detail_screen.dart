import 'package:benkan_app/Models/AvisComModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:benkan_app/Models/PostModel.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class AvisDetailScreen extends StatefulWidget {
  final AvisCom avis;
  const AvisDetailScreen({
    Key? key,
    required this.avis,
  }) : super(key: key);

  @override
  State<AvisDetailScreen> createState() => _AvisDetailScreenState();
}

class _AvisDetailScreenState extends State<AvisDetailScreen> {
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
        child: Hero(
          tag: "tag",
          child: Column(
            children: [
              ClipRRect(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        "https://www.gestion-benkan.ml/images/${widget.avis.image}",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.avis.titre,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                  style: TextButton.styleFrom(
                                      primary: Colors.black),
                                  onPressed: () async {
                                    final url = Uri.parse(
                                        "https://www.gestion-benkan.ml/images/${widget.avis.image}");

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
                          Divider(
                            height: 20,
                            thickness: 1,
                          ),
                          Text(
                            widget.avis.contenu,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    /*  Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(CupertinoIcons.hand_thumbsup),
                        Text("J'aime"),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.share),
                        Text("Partager"),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ), */
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
