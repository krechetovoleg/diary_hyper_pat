import 'package:sqflite/sqflite.dart';
import 'package:diary_hyper_pat/database/database_service.dart';
import 'package:diary_hyper_pat/models/dhp_filter_model.dart';

class DhpFilterDB {
  Future<void> createTable(Database db) async {
    await db.execute("""create table if not exists dhp_filter(
      "id" innt not null,
      "type" text not null,
      "defaults" int,
      "dfrom" text null,
      "dto" text null
    );""");

    await db.rawInsert(
        '''insert into dhp_filter(id, type, defaults, dfrom, dto) values(?,?,?,?,?)''',
        [0, 'Все', 1, '', '']);
    await db.rawInsert(
        '''insert into dhp_filter(id, type, defaults, dfrom, dto) values(?,?,?,?,?)''',
        [1, 'За последние 30 дней', 0, '', '']);
    await db.rawInsert(
        '''insert into dhp_filter(id, type, defaults, dfrom, dto) values(?,?,?,?,?)''',
        [2, 'За последние 7 дней', 0, '', '']);
    await db.rawInsert(
        '''insert into dhp_filter(id, type, defaults, dfrom, dto) values(?,?,?,?,?)''',
        [3, 'Период', 0, '', '']);
  }

  Future<DhpFiltrer> fetchDhpFilter() async {
    final db = await DatabaseService().database;
    final dhpsfilter = await db.rawQuery(
        '''select id, type, defaults, dfrom, dto from dhp_filter order by defaults desc limit 1''');
    return DhpFiltrer.fromJson(dhpsfilter.first);
  }

  Future<void> updateData(
      {required int id, required String dfrom, required String dto}) async {
    final db = await DatabaseService().database;

    await db.update(
      'dhp_filter',
      {
        'defaults': DateTime.now().millisecondsSinceEpoch,
        'dfrom': dfrom,
        'dto': dto,
      },
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }
}
