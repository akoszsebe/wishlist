import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:wishlist/src/networking/providers/todo_Api_provider.dart';
import 'package:wishlist/src/networking/request/todo_request.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';

class Con extends ControllerMVC {
  factory Con() {
    if (_this == null) _this = Con._();
    return _this;
  }
  static Con _this;

  Con._();

  static Con get con => _this;

  List<TodoResponse> list;

  final TodoApiProvider todoApiProvider = TodoApiProvider();

  void init() => loadData();

  Future<void> loadData() async {
    List<TodoResponse> resopnse =
        await todoApiProvider.getTodos().catchError((error) {
      throw error;
    });
    list = resopnse;
    refresh();
    return;
  }

  Future<void> saveTodo(String title, String content) async {
    await todoApiProvider
        .addTodo(TodoRequest(
            title: title, content: content, userId: "zsebea@yahoo.com"))
        .catchError((error) {
      throw error;
    }).then((onValue) => {loadData()});
  }
}
