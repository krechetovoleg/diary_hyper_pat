import 'package:diary_hyper_pat/database/dhp_db.dart';
import 'package:diary_hyper_pat/database/dhpfilter_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }
}

Future<String> get fullPath async {
  const dbname = "dhp.db";
  final path = await getDatabasesPath();
  return join(path, dbname);
}

Future<Database> _initialize() async {
  final path = await fullPath;
  var db = await openDatabase(path,
      version: 1, singleInstance: true, onCreate: _createDB);
  return db;
}

Future<void> _createDB(Database db, int version) async {
  await DhpDB().createTable(db);
  await DhpFilterDB().createTable(db);
}
