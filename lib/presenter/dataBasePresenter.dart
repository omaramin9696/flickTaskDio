import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class db {
  String _searchText;

  db(String st) {
    this._searchText = st;
  }

  Future<Database> openDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String path = appDocPath + 'test.db';
    final Database database = await openDatabase(path, version: 1,);
    return database;
  }


  Future<String> DBPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'test.db');
    return path;
  }

  Future<void> insertDB(Map<String,Uint8List> ci) async {
    final Database db = await openDB();
    await db.execute("DROP TABLE IF EXISTS $_searchText");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${_searchText.trim()} (id TEXT PRIMARY KEY,imageBytes BLOB)");
      await db.transaction((txn) async {
     ci.forEach((key, value)async {
       await db.rawInsert(
           'INSERT INTO $_searchText (id , imageBytes) VALUES(?,?)', [key,value]);
     });
    });
    print('insert into $_searchText');
  }

  Future<List<Uint8List>> retriveDB() async {
    List<Uint8List>returnedList=[];
    final Database db = await openDB();
    List<Map> list = await db.rawQuery('SELECT * FROM $_searchText');
    for(int i=0;i<list.length;i++)
      {
       returnedList.add(list[i]['imageBytes']);
      }

    return returnedList;
  }

  Future<void> deleteDB() async {
    await deleteDatabase(await DBPath());
  }
}