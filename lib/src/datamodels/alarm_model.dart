class AlarmModel {
  String alarm;
  String title;
  int id;

  AlarmModel({this.alarm, this.title, this.id});

  factory AlarmModel.fromJson(Map<String, dynamic> json) => new AlarmModel(
      alarm: json["alarm"], title: json["title"], id: json["id"]);

  Map<String, dynamic> toJson() =>
      {"alarm": alarm, "title": title, "id": id};
}
