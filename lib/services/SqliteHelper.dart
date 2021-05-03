import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:qoutes_app/models/Images.dart';
import 'package:qoutes_app/provider/LikeProvider.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/CutomToast.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  Database _database;
  bool chek;

  Future<void> openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'Quote.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE quote(p_id TEXT PRIMARY KEY ,p_image TEXT )",
        );
      },
      version: 1,
    );
  }

  Future<void> AddPhoto(Images images) async {
    print(images.p_id);
    await openDb();
    final Database db = await _database;
    var result =
        await db.query("quote", where: "p_id=?", whereArgs: [images.p_id]);

    if (result.length == 0) {
      await db.insert(
        'quote',
        images.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      CustomToast.ShowToast('Added to liked Quotes');
    } else {
      //Show Message
      CustomToast.ShowToast('Already in liked Quotes');
    }
  }

  Future<void> DeletePhoto(String id) async {
    await openDb();
    final Database db = await _database;
    await db.delete(
      'quote',
      where: "p_id = ?",
      whereArgs: [id],
    );
  }

  Future GetData(LikeProvider likeProvider) async {
    await openDb();
    final Database db = await _database;
    var Values = await db.query('quote');
    List<Images> dataList = [];
    Values.forEach((i) {
      Images cart = Images.data(i["p_id"], i["p_image"]);
   //   print(i['p_id']);
      dataList.add(cart);
    });
    likeProvider.setLikedImages(dataList);
  }

  Future<void> isQuoteisLiked(String Id, LikeProvider likeProvider) async {
    await openDb();
    final Database db = await _database;
    var result = await db.query("quote", where: "p_id=?", whereArgs: [Id]);
   // print(result);
    if (result.isNotEmpty) {
      chek = true;
    } else {
      chek = false;
    }
  //  print(chek);
    // likeProvider.notifyListeners();
  }

  Future<void> getiteminCart(LikeProvider likeProvider) async {
    await openDb();
    // Get a reference to the database.
    var dbClient = await _database;
    var result = await dbClient.rawQuery("SELECT COUNT(*) FROM quote");
    int x = Sqflite.firstIntValue(result);
    likeProvider.Total=x;
  }
}
