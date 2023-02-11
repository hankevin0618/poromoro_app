import 'package:flutter/material.dart';
import 'package:flutter_app/models/webtoon_model.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:flutter_app/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: const Text(
          "Today's Toons",
          style: TextStyle(fontSize: 26),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(snapshot),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      itemBuilder: (context, index) {
        var webtoonData = snapshot.data![index];
        return Webtoon(
          title: webtoonData.title,
          thumb: webtoonData.thumb,
          id: webtoonData.id,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 40,
        );
      },
    );
  }
}
