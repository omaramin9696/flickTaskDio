import 'dart:typed_data';

import 'package:apibymetest/model/cachModel.dart';
import 'package:path/path.dart';
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

  Future<void> insertDB(Map<String,dynamic> ci) async {
    final Database db = await openDB();
    await db.execute("DROP TABLE IF EXISTS $_searchText");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${_searchText.trim()} (id TEXT PRIMARY KEY,imageBytes TEXT)");
    await db.transaction((txn) async {
     ci.forEach((key, value)async {
       await txn.rawInsert(
           'INSERT INTO $_searchText(id, imageBytes) VALUES(' +
               '\'' +
               key+
               '\'' +
               ',' +
               '\'' +
               value.toString() +
               '\'' +
               ')'
       );
     });
    });
  }

  Future<List<Uint8List>> retriveDB() async {
    List<Uint8List>returnedList=[];
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