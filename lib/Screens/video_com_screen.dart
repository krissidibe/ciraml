import 'package:benkan_app/Models/AvisComModel.dart';
import 'package:benkan_app/Models/PostModel.dart';
import 'package:benkan_app/Models/VideoModel.dart';
import 'package:benkan_app/Screens/avis_detail_screen.dart';
import 'package:benkan_app/Screens/post_detail_screen.dart';
import 'package:benkan_app/Services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoBenkaScreen extends StatefulWidget {
  const VideoBenkaScreen({Key? key}) : super(key: key);

  @override
  _VideoBenkaScreenState createState() => _VideoBenkaScreenState();
}

class _VideoBenkaScreenState extends State<VideoBenkaScreen> {
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
        future: HttpService.fetchAllVideo(),
        builder: (context, AsyncSnapshot<List<AvisCom>> snapshot) {
          if (snapshot.hasData) {
            List<AvisCom> datas = snapshot.data!;

            /*  return ListView(
              children: datas
                  .map((AvisCom item) => BuildItemVideo(item: item))
                  .toList(),
            ); */
          }
          return Center(
              child: CircularProgressIndicator(
            color: Color(0xFFe95022),
          ));
        },
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

class BuildItemVideo extends StatefulWidget {
  final VideoModel item;
  const BuildItemVideo({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<BuildItemVideo> createState() => _BuildItemVideoState();
}

class _BuildItemVideoState extends State<BuildItemVideo> {
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: widget.item.idVideo,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return GestureDetector(
      onTap: () {},
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
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressColors: ProgressBarColors(
                        playedColor: Color.fromARGB(255, 255, 152, 7),
                        handleColor: Color.fromARGB(255, 255, 0, 0),
                      ),
                    ),
                    Text(
                      widget.item.titre,
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
                    Text(
                      widget.item.contenu,
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
            ],
          )),
        ),
      ),
    );
  }
}
