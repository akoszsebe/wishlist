class TodoResponse {
  int id;
  String title;
  String content;
  int category;
  String userId;

  TodoResponse({this.id, this.title, this.content, this.category, this.userId});

  factory TodoResponse.fromJson(Map<String, dynamic> json) => new TodoResponse(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      category: json["category"],
      userId: json["user_id"]);
}