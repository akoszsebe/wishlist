import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:wishlist/src/datamodels/user_model.dart';
import 'package:wishlist/src/networking/providers/notification_api_provider.dart';
import 'package:wishlist/src/networking/providers/todo_Api_provider.dart';
import 'package:wishlist/src/networking/request/todo_request.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/util/firebasenotifications.dart';
import 'package:wishlist/util/shared_prefs.dart';

class TodoController extends ControllerMVC {
  factory TodoController() {
    if (_this == null) _this = TodoController._();
    return _this;
  }
  static TodoController _this;

  TodoController._();

  static TodoController get con => _this;

  List<TodoResponse> list;
  UserModel userData = UserModel(photoUrl: "");

  final TodoApiProvider todoApiProvider = TodoApiProvider();
  final NotificationApiProvider notificationApiProvider =
      NotificationApiProvider();
  FirebaseNotifications _firebaseNotifications;

  void init() async {
    _firebaseNotifications = new FirebaseNotifications();
    _firebaseNotifications..setUpFirebase();
    String firebaseDeviceId = await _firebaseNotifications.getToken();
    print(firebaseDeviceId);
    registerForNotification(firebaseDeviceId, userData.email);
    loadData();
  }

  Future<void> loadData() async {
    userData = await SharedPrefs.getUserData();
    refresh();
    List<TodoResponse> resopnse =
        await todoApiProvider.getTodos().catchError((error) {
      throw error;
    });
    list = resopnse;
    refresh();
    return;
  }

  Future<void> saveTodo(String title, String content) async {
    list = null;
    await todoApiProvider
        .addTodo(TodoRequest(
            title: title, content: content, userId: "zsebea@yahoo.com"))
        .catchError((error) {
      throw error;
    }).then((onValue) => {loadData()});
  }

  Future<void> deleteTodo(int id) async {
    list = null;
    await todoApiProvider
        .deleteTodo(DeleteTodoRequest(id: id))
        .catchError((error) {
      throw error;
    }).then((onValue) => {loadData()});
  }

  Future<void> update(int id, String title, String content) async {
    list = null;
    await todoApiProvider
        .updateTodo(UpdateTodoRequest(id: id, title: title, content: content))
        .catchError((error) {
      throw error;
    }).then((onValue) => {loadData()});
  }

  Future<void> registerForNotification(String token, String userId) async {
    list = null;
    await notificationApiProvider
        .registerForPushNotification(token, userId)
        .catchError((error) {
      throw error;
    }).then((onValue) => {});
  }

  Future<void> notifyTodo(String title, String message) async {
    list = null;
    await notificationApiProvider
        .notifyTodo(title, message)
        .catchError((error) {
      throw error;
    }).then((onValue) => {loadData()});
  }

  void addNotificationListener(Function(String, String) listener) {
    _firebaseNotifications.addListener(listener);
  }
}
