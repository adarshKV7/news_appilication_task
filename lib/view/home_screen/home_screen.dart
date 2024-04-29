// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_appilication_task/controller/home_screen_controller.dart';
import 'package:news_appilication_task/core/constants/color_constants.dart';
import 'package:news_appilication_task/view/home_screen/news_read_screen/news_read_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String? selectedDropDown;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<HomeController>().getHeadlines();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerObj = context.watch<HomeController>();
    return DefaultTabController(
      length: providerObj.lstCategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("NEWS"),
          actions: [
            DropdownButton(
              value: selectedDropDown,
              hint: Text("Select"),
              style: TextStyle(color: ColorConstants.primaryBlack),
              items: List.generate(
                  providerObj.Country.length,
                  (index) => DropdownMenuItem(
                        child: Text(providerObj.Country[index].toUpperCase()),
                        value: providerObj.Country[index],
                      )),
              onChanged: (value) {
                selectedDropDown = value;
                int selectedIndex =
                    providerObj.Country.indexWhere((items) => items == value);
                providerObj.getSelectedCountryIndex(selectedIndex);
              },
            ),
            SizedBox(
              width: 30,
            ),
            Icon(Icons.share),
            SizedBox(
              width: 30,
            ),
          ],
          bottom: TabBar(
              isScrollable: true,
              padding: EdgeInsets.zero,
              onTap: (value) {
                providerObj.getSelectedCategoryIndex(value);
              },
              tabs: List.generate(
                providerObj.lstCategories.length,
                (index) => Tab(
                  child:
                      Text("${providerObj.lstCategories[index].toUpperCase()}"),
                ),
              )),
        ),

        drawer: Drawer(),

        body: providerObj.isLoading == true
            ? Center(child: CircularProgressIndicator())
            : providerObj.newsResModel?.articles?.length == null ||
                    providerObj.newsResModel?.articles?.length == 0
                ? Center(child: Text("No Data Found"))
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsReadScreen(
                                      articles: providerObj
                                          .newsResModel?.articles?[index]),
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  height: 200,
                                  imageUrl: providerObj.newsResModel
                                          ?.articles?[index].urlToImage ??
                                      "",
                                  errorWidget: (context, url, error) => Image.asset(
                                      "assests/images/No-Image-Placeholder.svg.png"),
                                ),
                                Text(
                                  providerObj.newsResModel?.articles?[index]
                                          .title ??
                                      "",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  providerObj.newsResModel?.articles?[index]
                                          .description ??
                                      "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 5,
                        ),
                    itemCount: providerObj.newsResModel?.articles?.length ?? 0),

        // : ListView.builder(
        //     itemCount: providerObj.newsResModel?.articles?.length ?? 0,
        //     itemBuilder: (context, index) => ListTile(
        //       title: Text(
        //           providerObj.newsResModel?.articles?[index].title ?? ""),
        //     ),
        //   ),
      ),
    );
  }
}
