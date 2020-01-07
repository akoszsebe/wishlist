class TodoRequest {
  String title;
  String content;
  String userId;

  TodoRequest({this.title, this.content, this.userId});

  factory TodoRequest.fromJson(Map<String, dynamic> json) => new TodoRequest(
      title: json["title"], content: json["content"], userId: json["user_id"]);

  factory TodoRequest.fromJsonNullable(Map<String, dynamic> json) {
    TodoRequest response = TodoRequest();
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

  Map<String, dynamic> toJson() =>
      {"title": title, "content": content, "user_id": userId};
}

class DeleteTodoRequest {
  int id;
  
  DeleteTodoRequest({this.id});

  factory DeleteTodoRequest.fromJson(Map<String, dynamic> json) => new DeleteTodoRequest(
      id: json["id"]);

  Map<String, dynamic> toJson() =>
      {"id": id};
}