class AlarmModel {
  String alarm;
  String title;
  int id;
  int when;

  AlarmModel({this.alarm, this.title, this.id, this.when});

  factory AlarmModel.fromJson(Map<String, dynamic> json) => new AlarmModel(
      alarm: json["alarm"], title: json["title"], id: json["id"]);

  Map<String, dynamic> toJson() => {"alarm": alarm, "title": title, "id": id};

  AlarmModel.fromMap(Map<String, dynamic> map) {
    id = map["_id"];
    title = map["_title"];
    when = map["_when"];
  }

  Map<String, dynamic> toMap() => {"_id": id, "_title": title, "_when": when};
}
