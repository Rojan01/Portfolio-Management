import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:portfolio_management/models/share_data.dart';




class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String shareDataTable = 'shareData_table';
  String colId = 'id';
  String colScrip = 'scrip';
  String colCompanyName = 'companyName';
  String colSectorName = 'sectorName';
  String colQuantity = 'quantity';
  String colPrice = 'price';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'shareData.db';

    // Open/create the database at a given path
    var shareDataDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return shareDataDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $shareDataTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colScrip TEXT, $colCompanyName TEXT,$colSectorName TEXT, $colQuantity INTEGER, $colPrice INTEGER)');
  }

  // Fetch Operation: Get all shareData objects from database
  Future<List<Map<String, dynamic>>> getShareDataMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(shareDataTable, orderBy: '$colPrice ASC');
    return result;
  }

  // Insert Operation: Insert a ShareData object to database
  Future<int> insertShareData(ShareData shareData) async {
    Database db = await this.database;
    var result = await db.insert(shareDataTable, shareData.toMap());
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteShareData(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $shareDataTable WHERE $colId = $id');
    return result;
  }

  // Get number of ShareData objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $shareDataTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'ShareData List' [ List<Note> ]
  Future<List<ShareData>> getShareDataList() async {
    var shareDataMapList =
        await getShareDataMapList(); // Get 'Map List' from database
    int count =
        shareDataMapList.length; // Count the number of map entries in db table

    List<ShareData> shareDataList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      shareDataList.add(ShareData.fromMapObject(shareDataMapList[i]));
    }

    return shareDataList;
  }
}
