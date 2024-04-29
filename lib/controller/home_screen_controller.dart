import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_appilication_task/model/news_api_model.dart';

class HomeController with ChangeNotifier {
  NewsResModel? newsResModel;
  bool isLoading = false;
  int selectedCategoryIndex = 0;
  int selectedCountryIndex = 0;
  List<String> lstCategories = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology"
  ];

  List<String> Country = [
    "ae",
    "ar",
    "ata",
    "ub",
    "eb",
    "gb",
    "rc",
    "ach",
    "cn",
    "co",
    "cu",
    "cz",
    "de",
    "eg",
    "fr",
    "gb",
    "gr",
    "hk",
    "hu",
    "id",
    "ie",
    "il",
    "in",
    "it",
    "jp",
    "kr",
    "lt",
    "lv",
    "ma",
    "mx",
    "my",
    "ng",
    "nl",
    "no",
    "nz",
    "ph",
    "pl",
    "pt",
    "ro",
    "rs",
    "ru",
    "sa",
    "se",
    "sg",
    "sk",
    "th",
    "tr",
    "tw",
    "ua",
    "us",
    "ve",
    "za"
  ];

  Future getHeadlines() async {
    isLoading = true;
    notifyListeners();
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=${Country[selectedCountryIndex]}&category=${lstCategories[selectedCategoryIndex]}&apiKey=de554a3db716476597378b90d881b486");

    var res = await http.get(url);

    if (res.statusCode == 200) {
      print(res);
      var decodedData = jsonDecode(res.body);
      newsResModel = NewsResModel.fromJson(decodedData);
      notifyListeners();
    } else {
      print("failed");
    }
    isLoading = false;
    notifyListeners();
  }

  void getSelectedCategoryIndex(int value) {
    selectedCategoryIndex = value;
    getHeadlines();
    notifyListeners();
  }

  void getSelectedCountryIndex(int value) {
    selectedCountryIndex = value;
    getHeadlines();
    notifyListeners();
  }
}
