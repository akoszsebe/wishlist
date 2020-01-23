class AlarmModel {
  String alarm;
  String title;
  int id;
  int when;
  bool alarmEnabled;

  AlarmModel({this.alarm, this.title, this.id, this.when,this.alarmEnabled});

  factory AlarmModel.fromJson(Map<String, dynamic> json) => new AlarmModel(
      alarm: json["alarm"], title: json["title"], id: json["id"]);

  Map<String, dynamic> toJson() => {"alarm": alarm, "title": title, "id": id};

  AlarmModel.fromMap(Map<String, dynamic> map) {
    id = map["_id"];
    title = map["_title"];
    when = map["_when"];
    alarmEnabled = map["_alarmEnabled"] == 0 ? true : false;
  }

  Map<String, dynamic> toMap() => {
        "_id": id,
        "_title": title,
        "_when": when,
        "_alarmEnabled": alarmEnabled ? 0 : 1
      };
}
