import 'package:flutter/material.dart';
import 'package:flutter_app/models/webtoon_detail_model.dart';
import 'package:flutter_app/models/webtton_episode_model.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:flutter_app/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');

    if (likedToons != null) {
      if (likedToons.contains(widget.id)) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        actions: [
          IconButton(
              onPressed: onHeartTap,
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_outline_outlined,
              ))
        ],
        elevation: 1,
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: const Text(
          "Today's Toons",
          style: TextStyle(fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        child: Hero(
          tag: widget.id,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 50,
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          offset: const Offset(5, 10),
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: Image.network(widget.thumb),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(
                            episode: episode,
                            webtoonId: widget.id,
                          )
                      ],
                    );
                  }
                  return Container();
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
