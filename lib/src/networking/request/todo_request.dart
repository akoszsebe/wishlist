class TodoRequest {
  String title;
  String content;
  String userId;

  TodoRequest({this.title, this.content, this.userId});

  factory TodoRequest.fromJson(Map<String, dynamic> json) => new TodoRequest(
      title: json["title"], content: json["content"], userId: json["user_id"]);

  Map<String, dynamic> toJson() =>
      {"title": title, "content": content, "user_id": userId};
}

class DeleteTodoRequest {
  int id;

  DeleteTodoRequest({this.id});

  factory DeleteTodoRequest.fromJson(Map<String, dynamic> json) =>
      new DeleteTodoRequest(id: json["id"]);

  Map<String, dynamic> toJson() => {"id": id};
}

class UpdateTodoRequest {
  int id;
  String title;
  String content;

  UpdateTodoRequest({this.id, this.title, this.content});

  factory UpdateTodoRequest.fromJson(Map<String, dynamic> json) =>
      new UpdateTodoRequest(
          id: json["id"], title: json["title"], content: json["content"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "title": title, "content": content};
}
