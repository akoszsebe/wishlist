class PushNotificationModel {
  String title;
  String content;
  int type = 0;

  PushNotificationModel({this.title, this.content, this.type});

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) =>
      new PushNotificationModel(
          title: json["data"]["title"], content: json["data"]["body"], type: json["data"]["type"]);

  factory PushNotificationModel.fromJsonNullable(Map<String, dynamic> json) {
    PushNotificationModel response = PushNotificationModel();
    if (json.containsKey("data")) {
      if (json["data"].containsKey("title")) {
        response.title = json["data"]["title"];
      }
      if (json["data"].containsKey("body")) {
        response.content = json["data"]["body"];
      }
      if (json["data"].containsKey("type")) {
        response.type = json["data"]["type"];
      }
    }
    return response;
  }

  Map<String, dynamic> toJson() =>
      {"title": title, "body": content, "type": type};
}
