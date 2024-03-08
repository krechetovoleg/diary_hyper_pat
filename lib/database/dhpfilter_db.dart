import 'package:sqflite/sqflite.dart';
import 'package:diary_hyper_pat/database/database_service.dart';
import 'package:diary_hyper_pat/models/dhp_filter_model.dart';

class DhpFilterDB {
  final tableNameFilt = 'dhp_filter';

  Future<void> createTable(Database db) async {
    await db.execute("""create table if not exists $tableNameFilt(
      "id" innt not null,
      "type" text not null,
      "defaults" int,
      "dfrom" text null,
      "dto" text null
    );""");

    await db.rawInsert('''insert into $tableNameFilt(id, type, defaults, dfrom, dto) values(?,?,?,?,?)''', [0, 'Все', 1, '', '']);
    await db.rawInsert('''insert into $tableNameFilt(id, type, defaults, dfrom, dto) values(?,?,?,?,?)''', [1, 'Последние 30 дней', 0, '', '']);
    await db.rawInsert('''insert into $tableNameFilt(id, type, defaults, dfrom, dto) values(?,?,?,?,?)''', [2, 'Последние 7 дней', 0, '', '']);
    await db.rawInsert('''insert into $tableNameFilt(id, type, defaults, dfrom, dto) values(?,?,?,?,?)''', [3, 'Период', 0, '', '']);
  }

  Future<DhpFiltrer> fetchDhpFilter() async {
    final db = await DatabaseService().database;
    final dhpsfilter = await db.rawQuery('''select id, type, defaults, dfrom, dto from $tableNameFilt where defaults = 1''');
    return DhpFiltrer.fromJson(dhpsfilter.first);
  }

  Future<void> updateData({required int id, required int defaults, required String dfrom, required String dto}) async {
    final db = await DatabaseService().database;

    await db.execute("update $tableNameFilt set defaults = 0");

    await db.update(
      tableNameFilt,
      {
        'defaults': defaults,
        'dfrom': dfrom,
        'dto': dto,
      },
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }
}
