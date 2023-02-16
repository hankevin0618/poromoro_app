import 'package:flutter/material.dart';
import 'package:flutter_app/models/webtton_episode_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Episode extends StatelessWidget {
  final String webtoonId;
  const Episode({
    super.key,
    required this.episode,
    required this.webtoonId,
  });

  final WebtoonEpisodeModel episode;

  // url_launcher 깔고 진행해야되는데 안했음
  onButtonTap() async {
    final url = Uri.parse("https://google.com/$webtoonId/$episode");
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.green.shade400,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 40,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(episode.title),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
