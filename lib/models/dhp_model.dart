class Dhp {
  int id = 0;
  int syst = 120;
  int dist = 60;
  int pulse = 65;
  String wellbeing = "";
  String comment = "";
  String dates = "";
  String times = "";
  String dhpcolor = "";
  String dhpname = "";
  int sort = 0;

  Dhp(
      {required this.id,
      required this.syst,
      required this.dist,
      required this.pulse,
      required this.wellbeing,
      required this.comment,
      required this.dates,
      required this.times,
      required this.dhpcolor,
      required this.dhpname,
      required this.sort});

  factory Dhp.fromJson(Map<String, dynamic> json) => Dhp(
        id: json['id'] ?? 0,
        syst: json['syst'] ?? 0,
        dist: json['dist'] ?? 0,
        pulse: json['pulse'] ?? 0,
        wellbeing: json['wellbeing'] ?? '',
        comment: json['comment'] ?? '',
        dates: json['dates'] ?? '',
        times: json['times'] ?? '',
        dhpcolor: json['dhpcolor'] ?? '',
        dhpname: json['dhpname'] ?? '',
        sort: json['sort'] ?? 0,
      );

  static List<Map<String, dynamic>> fetchData(List dhps) {
    final List<Map<String, dynamic>> datas;
    datas = dhps
        .map((s) => {
              'id': s.id.toString(),
              'syst': s.syst.toString(),
              'dist': s.dist.toString(),
              'pulse': s.pulse.toString(),
              'wellbeing': s.wellbeing,
              'comment': s.comment,
              'dates': s.dates,
              'times': s.times,
              'dhpcolor': s.dhpcolor,
              'dhpname': s.dhpname,
              'sort': s.sort
            })
        .toList();
    return datas;
  }
}
