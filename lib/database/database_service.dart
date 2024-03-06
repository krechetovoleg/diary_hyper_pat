import 'package:diary_hyper_pat/database/dhp_db.dart';
import 'package:diary_hyper_pat/database/dhpfilter_db.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }
}

Future<Database> _initialize() async {
  final getDirectory = await getDatabasesPath();
  final path = "$getDirectory/dhp.db";
  var db = await openDatabase(path, version: 1, singleInstance: true, onCreate: _createDB);
  return db;
}

void _createDB(Database db, int version) async {
  await DhpFilterDB().createTable(db);
  await DhpDB().createTable(db);
}
