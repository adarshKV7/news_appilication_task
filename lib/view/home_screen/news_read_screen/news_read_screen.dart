

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_appilication_task/model/news_api_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsReadScreen extends StatelessWidget {
  NewsReadScreen({super.key, required this.articles});

  final Article? articles;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              CachedNetworkImage(
                height: 200,
                imageUrl: "${articles?.urlToImage}",
                errorWidget: (context, url, error) =>
                    Image.asset("assests/images/No-Image-Placeholder.svg.png"),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                articles?.title ?? "",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                articles?.description ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse(articles?.url ?? ""));
                  },
                  child: Text("Read More"))
            ],
          ),
        ),
      ),
    );
  }
}
