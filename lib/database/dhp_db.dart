import 'package:sqflite/sqflite.dart';
import 'package:diary_hyper_pat/database/database_service.dart';
import 'package:diary_hyper_pat/models/dhp_model.dart';

class DhpDB {
  final tableName = 'dhp_data';
  final tableNameSet = 'dhp_set';

  Future<void> createTable(Database db) async {
    await db.execute("""create table if not exists $tableName(
      "id" integer not null,
      "syst" integer not null,
      "dist" integer not null,
      "pulse" integer null,
      "wellbeing" text null,
      "comment" text null,
      "dates" text not null,
      "times" text not null,
      "int1" integer null,
      "int2" integer null,
      "int3" integer null,
      "int4" integer null,
      "int5" integer null,
      "real1" real null,
      "real2" real null,
      "real3" real null,
      "real4" real null,
      "real5" real null,
      "text1" text null,
      "text2" text null,
      "text3" text null,
      "text4" text null,
      "text5" text null,
      primary key("id" autoincrement)
    );""");

    await db.execute("""create table if not exists $tableNameSet(
      "id" integer not null,
      "sort" integer not null,
      "name" text not null,
      "syst_min" integer not null,
      "syst_max" integer not null,
      "dist_min" integer not null,
      "dist_max" integer not null,
      "dhpcolor" text not null
    );""");

    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [1, 9, 'Возможно: очень серьезная гипотония', 0, 59, 0, 39, '3802f7']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [2, 8, 'Возможно: серьезная гипотония', 60, 89, 40, 59, '6a41f9']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [3, 7, 'Возможно: пограничная гипотония', 90, 109, 60, 74, '9c81fb']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [4, 6, 'Возможно: низко нормальное', 110, 119, 75, 79, 'cdc0fd']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [5, 5, 'Возможно: нормальное', 120, 129, 80, 84, '4ab241']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [6, 6, 'Возможно: высоко нормальное', 130, 139, 85, 89, 'ffcccc']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [7, 7, 'Возможно: гипертония 1 степени', 140, 159, 90, 99, 'ff9999']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [8, 8, 'Возможно: гипертония 2 степени', 160, 179, 100, 109, 'ff6666']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [9, 9, 'Возможно: гипертония 3 степени', 180, 209, 110, 119, 'ff3333']);
    await db.rawInsert(
        '''insert into $tableNameSet (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [
          10,
          10,
          'Возможно: гипертония 4 степени',
          210,
          999,
          120,
          999,
          'ff0000'
        ]);
  }

  Future<int> insertData(
      {required int syst,
      required int dist,
      required int pulse,
      required String wellbeing,
      required String comment,
      required String dates,
      required String times}) async {
    final db = await DatabaseService().database;
    return await db.rawInsert(
        '''insert into $tableName (syst, dist, pulse, wellbeing, comment, dates, times) values(?,?,?,?,?,?,?)''',
        [
          syst,
          dist,
          pulse,
          wellbeing,
          comment,
          dates,
          times,
        ]);
  }

  Future<List<Dhp>> fetchAllData() async {
    final db = await DatabaseService().database;
    final dhps = await db.rawQuery(
        '''select t.id, t.syst, t.dist, t.pulse, t.wellbeing, t.comment, t.dates, t.times, tt.dhpcolor, tt.name as dhpname
    from $tableName as t
    left join $tableNameSet tt on tt.id = 
    (select id from 
        (
          select id, name, dhpcolor,sort from $tableNameSet as s1 where t.syst between syst_min and syst_max 
          union 
          select id, name, dhpcolor,sort from $tableNameSet as s2 where t.dist between dist_min and dist_max
        ) order by sort desc limit 1
    )     
    order by dates desc, times desc''');
    return dhps.map((dhp) => Dhp.fromJson(dhp)).toList();
  }

  Future<void> deleteData(int id) async {
    final db = await DatabaseService().database;
    await db.rawDelete('''delete from $tableName where id = ?''', [id]);
  }

  Future<int> updateData(
      {required int id,
      required int syst,
      required int dist,
      required int pulse,
      required String wellbeing,
      required String comment,
      required String dates,
      required String times}) async {
    final db = await DatabaseService().database;

    return await db.update(
      tableName,
      {
        'syst': syst,
        'dist': dist,
        'pulse': pulse,
        'wellbeing': wellbeing,
        'comment': comment,
        'dates': dates,
        'times': times,
      },
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }
}
