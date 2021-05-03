import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qoutes_app/models/Category.dart';
import 'package:qoutes_app/models/Images.dart';

class ApiData {
  Future<List<Images>> qouteofday() async {
    List<Images> Albumlist = [];
    var data = await http.get('http://okeyquotes.com/app/qoute_day.php');
    var jsonData = json.decode(data.body);
    jsonData.forEach((data) {
      Images image = Images.data(data["sub_id"], data["sub_img"]);
      Albumlist.add(image);
    });

    print(Albumlist);
    return Albumlist;
  }

  Future<List<Images>> trending() async {
    List<Images> Albumlist = [];
    var data = await http.get("http://okeyquotes.com/app/trendingqoute.php");
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Images images = Images.data(u["sub_id"], u["sub_img"]);
      Albumlist.add(images);
    }
    print(Albumlist);
    return Albumlist;
  }

  Future<List<Category>> PopularCategories() async {
    List<Category> list = [];
    var data =
        await http.get("http://okeyquotes.com/app/popular_cat_qote.php");
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Category cat = Category(u["cat_id"], u["cat_name"], u["cat_img"]);
      list.add(cat);
    }
    print(list);
    return list;
  }

  Future<List<Category>> AllCategories() async {
    List<Category> list = [];
    var data = await http.get("http://okeyquotes.com/app/get_category.php");
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Category cat = Category(u["cat_id"], u["cat_name"], u["cat_img"]);
      list.add(cat);
    }
    print(list);
    return list;
  }

  Future<List<Category>> Searchqoute(String tag) async {
    List<Category> list = [];
    var data = await http.get(
        "http://okeyquotes.com/app/qouteSearch.php" + "?search_tag=" + tag);
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Category cat = Category(u["cat_id"], u["cat_name"], u["cat_img"]);
      list.add(cat);
    }
    print(list);
    return list;
  }

  Future<List<Images>> Allqoutespfday() async {
    List<Images> Albumlist = [];
    var data =
        await http.get("http://okeyquotes.com/app/getall__qoutesof_day.php");
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Images images = Images.data(u["sub_id"], u["sub_img"]);
      Albumlist.add(images);
    }
    print(Albumlist);
    return Albumlist;
  }

  Future<List<Images>> GetAllTrendings() async {
    List<Images> Albumlist = [];
    var data =
        await http.get("http://okeyquotes.com/app/getalltrendings.php");
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Images images = Images.data(u["sub_id"], u["sub_img"]);
      Albumlist.add(images);
    }
    print(Albumlist);
    return Albumlist;
  }

  Future<List<Images>> GetSubCategories(String id) async {
    List<Images> Albumlist = [];
    var data = await http
        .get("http://okeyquotes.com/app/get_product.php" + "?cat_id=" + id);
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Images images = Images.data(u["sub_id"], u["sub_img"]);
      Albumlist.add(images);
    }
    print(Albumlist);
    return Albumlist;
  }
}
