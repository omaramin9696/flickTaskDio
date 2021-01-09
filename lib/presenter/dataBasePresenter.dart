import 'dart:typed_data';

import 'package:apibymetest/model/cachModel.dart';
import 'package:apibymetest/model/flickModel.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class db {
  String _searchText;

  db(String st) {
    this._searchText = st;
  }

  Future<Database> openDB() async {
    final Database database = await openDatabase('test.db', version: 1,);
    return database;
  }


  Future<String> DBPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'test.db');
    return path;
  }

  Future<void> insertDB(List<cachimg> ci) async {
    await deleteDB();
    final Database db = await openDB();
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${_searchText.trim()} (id TEXT PRIMARY KEY,imageBytes TEXT)");
    await db.transaction((txn) async {
      for(int x=0;x<ci.length;x++)
        await txn.rawInsert(
          'INSERT INTO $_searchText(id, imageBytes) VALUES(' +
              '\'' +
              ci[x].imgId+
              '\'' +
              ',' +
              '\'' +
              ci[x].imgb.toString() +
              '\'' +
              ')'
      );
    });
  }

  Future<List<Uint8List>> retriveDB() async {
    List<Uint8List>returnedList;
    final Database db = await openDB();
    final List<Map<String, dynamic>> maps = await db.query('$_searchText');
     List.generate(maps.length, (i) {
     returnedList.add( maps[i]['imageBytes']);
    });
    return returnedList;
  }

  Future<void> deleteDB() async {
    await deleteDatabase(await DBPath());
  }
}