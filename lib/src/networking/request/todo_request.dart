class TodoRequest {
  String title;
  String content;
  String userId;
  int category;

  TodoRequest({this.title, this.content, this.userId, this.category = 0});

  factory TodoRequest.fromJson(Map<String, dynamic> json) => new TodoRequest(
      title: json["title"],
      content: json["content"],
      userId: json["user_id"],
      category: json["category"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "user_id": userId,
        "category": category
      };
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
  int category;

  UpdateTodoRequest({this.id, this.title, this.content, this.category});

  factory UpdateTodoRequest.fromJson(Map<String, dynamic> json) =>
      new UpdateTodoRequest(
          id: json["id"],
          title: json["title"],
          content: json["content"],
          category: json["category"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "title": title, "content": content, "category": category};
}
