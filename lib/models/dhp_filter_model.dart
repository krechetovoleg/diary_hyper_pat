class DhpFiltrer {
  int id = 0;
  String type = "";
  int defaults = 0;
  String dfrom = "";
  String dto = "";

  DhpFiltrer(
      {required this.id,
      required this.type,
      required this.defaults,
      required this.dfrom,
      required this.dto});

  factory DhpFiltrer.fromJson(Map<String, dynamic> json) => DhpFiltrer(
        id: json['id'] ?? 0,
        type: json['type'] ?? "",
        defaults: json['defaults'] ?? 0,
        dfrom: json['dfrom'] ?? 0,
        dto: json['dto'] ?? '',
      );
}
