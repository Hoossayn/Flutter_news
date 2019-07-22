import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  //Because we need to call init on the newsDbProvider instance we made at the bottom of this class
  NewsDbProvider(){
    init();
  }

  Future<ItemModel> fetchItem(int id)async{
   final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if(maps.length > 0){
     return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  //TODO - store and fetch top ids
  @override
  Future<List<int>> fetchTopIds() {
    // TODO: implement fetchTopIds
    return null;
  }

  void init() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, "items.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version){
         newDb.execute(""" 
         CREATE TABLE Items
         (
          id INTEGET PRIMARY KEY,
          type TEXT,
          time TEXT,
          parent INTEGER,
          kids BLOB,
          dead INTEGER,
          deleted INEGER,
          url TEXT,
          score INTEGER,
          title TEXT,
          desendants INTEGER
         )
         """);
      },
    );

  }

  Future<int> addItem(ItemModel item){
    return db.insert("Items",
      item.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
  Future<int> clear()  {
    return db.delete("Items");
  }
}

// Because sqlite doesn't like to open multiple connection to thesame database
final newsDbProvider = NewsDbProvider();