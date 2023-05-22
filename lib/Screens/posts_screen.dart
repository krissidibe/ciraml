import 'dart:io';

import 'package:benkan_app/Models/PostModel.dart';
import 'package:benkan_app/Screens/post_detail_screen.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
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
          /*   Icon(Icons.search), */
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: FutureBuilder(
        future: HttpService.fetchAllPost(),
        builder: (context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            List<Post> datas = snapshot.data!;

            return ListView(
              children: datas.map((Post item) => BuildItem(item)).toList(),
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

  GestureDetector BuildItem(Post item) {
    return GestureDetector(
      onTap: () {
        Get.to(PostDetailScreen(
          post: item,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.network(
                  item.image,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.titre,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      item.updated_at,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (item.contenu.length > 0)
                      Text(
                        item.contenu,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(fontSize: 15),
                      ),

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
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
/*                   TextButton.icon(
                      style: TextButton.styleFrom(primary: Colors.black),
                      onPressed: () {},
                      icon: Icon(CupertinoIcons.hand_thumbsup),
                      label: Text("Jaime")), */
                  TextButton.icon(
                      style: TextButton.styleFrom(primary: Colors.black),
                      onPressed: () async {
                        final url = Uri.parse(item.image);

                        final response = await http.get(url);
                        final bytes = response.bodyBytes;
                        final temp = await getTemporaryDirectory();
                        final path = "${temp.path}/image2.jpg";
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
            ],
          )),
        ),
      ),
    );
  }

/*  ListView.builder(itemCount: futureAllPost,
      itemBuilder: (context,index) => BuildCard(item:snapshot.data!),
      ) */
  BuildCard({image, titre, updated_at, contenu}) => Hero(
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
      );
}
