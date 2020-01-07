class TodoResponse {
  int id;
  String title;
  String content;
  String userId;

  TodoResponse({this.id, this.title, this.content, this.userId});

  factory TodoResponse.fromJson(Map<String, dynamic> json) => new TodoResponse(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      userId: json["user_id"]);

  factory TodoResponse.fromJsonNullable(Map<String, dynamic> json) {
    TodoResponse response = TodoResponse();
    if (json.containsKey("id")) {
      response.id = json["id"];
    }
    if (json.containsKey("title")) {
      response.title = json["title"];
    }
    if (json.containsKey("content")) {
      response.content = json["content"];
    }
    if (json.containsKey("user_id")) {
      response.userId = json["user_id"];
    }
    return response;
  }
}