import 'package:diary_hyper_pat/models/dhp_filter_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:diary_hyper_pat/database/database_service.dart';
import 'package:diary_hyper_pat/models/dhp_model.dart';

class DhpDB {
  Future<void> createTable(Database db) async {
    await db.execute("""create table if not exists dhp_data(
      "id" integer not null,
      "syst" integer not null,
      "dist" integer not null,
      "pulse" integer null,
      "wellbeing" text null,
      "comment" text null,
      "dates" text not null,
      "times" text not null,
      "sort" int not null,
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

    await db.execute("""create table if not exists dhp_set(
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
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [1, 9, 'Возможно: очень серьезная гипотония', 0, 59, 0, 39, '3802f7']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [2, 8, 'Возможно: серьезная гипотония', 60, 89, 40, 59, '6a41f9']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [3, 7, 'Возможно: пограничная гипотония', 90, 109, 60, 74, '9c81fb']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [4, 6, 'Возможно: низко нормальное', 110, 119, 75, 79, 'cdc0fd']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [5, 5, 'Возможно: нормальное', 120, 129, 80, 84, '4ab241']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [6, 6, 'Возможно: высоко нормальное', 130, 139, 85, 89, 'ffcccc']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [7, 7, 'Возможно: гипертония 1 степени', 140, 159, 90, 99, 'ff9999']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [8, 8, 'Возможно: гипертония 2 степени', 160, 179, 100, 109, 'ff6666']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
        [9, 9, 'Возможно: гипертония 3 степени', 180, 209, 110, 119, 'ff3333']);
    await db.rawInsert(
        '''insert into dhp_set (id, sort, name, syst_min, syst_max, dist_min, dist_max, dhpcolor) values(?,?,?,?,?,?,?,?)''',
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
      required String times,
      required int sort}) async {
    final db = await DatabaseService().database;
    return await db.rawInsert(
        '''insert into dhp_data (syst, dist, pulse, wellbeing, comment, dates, times, sort) values(?,?,?,?,?,?,?,?)''',
        [syst, dist, pulse, wellbeing, comment, dates, times, sort]);
  }

  Future<List<Dhp>> fetchAllData() async {
    final db = await DatabaseService().database;

    final dhpsfilter = await db.rawQuery(
        '''select id, type, defaults, dfrom, dto from dhp_filter order by defaults desc limit 1''');
    final fl = DhpFiltrer.fromJson(dhpsfilter.first);
    String dfrom, dto;

    if (fl.id == 0) {
      dfrom = '1900-01-01';
      dto = '2099-01-01';
    } else if (fl.id == 1) {
      dfrom = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 30)));
      dto = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } else if (fl.id == 2) {
      dfrom = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 7)));
      dto = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } else {
      dfrom =
          '${fl.dfrom.substring(6, 10)}-${fl.dfrom.substring(3, 5)}-${fl.dfrom.substring(0, 2)}';
      dto =
          '${fl.dto.substring(6, 10)}-${fl.dto.substring(3, 5)}-${fl.dto.substring(0, 2)}';
    }

    final dhps = await db.rawQuery(
        '''select t.id, t.syst, t.dist, t.pulse, t.wellbeing, t.comment, t.dates, t.times, tt.dhpcolor, tt.name as dhpname, t.sort || t.dates as sort      
    from dhp_data as t
    left join dhp_set tt on tt.id = 
    (select id from 
        (
          select id, name, dhpcolor,sort from dhp_set as s1 where t.syst between syst_min and syst_max 
          union 
          select id, name, dhpcolor,sort from dhp_set as s2 where t.dist between dist_min and dist_max
        ) order by sort desc limit 1
    )  
    where DATE(substr(dates,7,4)||'-'||substr(dates,4,2)||'-'||substr(dates,1,2)) between DATE(?) and DATE(?)
    ''', [dfrom, dto]);
    return dhps.map((dhp) => Dhp.fromJson(dhp)).toList();
  }

  Future<void> deleteData(int id) async {
    final db = await DatabaseService().database;
    await db.rawDelete('''delete from dhp_data where id = ?''', [id]);
  }

  Future<int> updateData({
    required int id,
    required int syst,
    required int dist,
    required int pulse,
    required String wellbeing,
    required String comment,
    required String dates,
    required String times,
    required int sort,
  }) async {
    final db = await DatabaseService().database;

    return await db.update(
      'dhp_data',
      {
        'syst': syst,
        'dist': dist,
        'pulse': pulse,
        'wellbeing': wellbeing,
        'comment': comment,
        'dates': dates,
        'times': times,
        'sort': sort
      },
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }
}
