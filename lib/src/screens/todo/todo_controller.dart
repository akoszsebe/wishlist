import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:wishlist/src/datamodels/push_notification_model.dart';
import 'package:wishlist/src/datamodels/user_model.dart';
import 'package:wishlist/src/networking/providers/notification_api_provider.dart';
import 'package:wishlist/src/networking/providers/todo_Api_provider.dart';
import 'package:wishlist/src/networking/request/todo_request.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/repository/session_repository.dart';
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
  UserModel userData;

  final TodoApiProvider todoApiProvider = TodoApiProvider();
  final NotificationApiProvider notificationApiProvider =
      NotificationApiProvider();
  FirebaseNotifications _firebaseNotifications;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  void init() async {
    _firebaseNotifications = new FirebaseNotifications();
    _firebaseNotifications..setUpFirebase();
    userData = await SharedPrefs.getUserData();
    refresh();
    String firebaseDeviceId = await _firebaseNotifications.getToken();
    print(firebaseDeviceId);
    SessionRepository().setFirebaseDeviceId(firebaseDeviceId);
    registerForNotification(firebaseDeviceId, userData.userId);
    loadData();
    initNotifSettings();
  }

  Future<void> initNotifSettings() async {
  var initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

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
    list = null;
    await todoApiProvider
        .addTodo(TodoRequest(
            title: title, content: content, userId: userData.userId))
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

  Future<void> updateCategory(int id, int category) async {
    list = null;
    await todoApiProvider.updateTodoCategory(id, category).catchError((error) {
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

  void addNotificationListener(Function(PushNotificationModel) listener) {
    _firebaseNotifications.addListener(listener);
  }

  void sendLocalNot(DateTime when,int id, String title, String content){
    _scheduleNotification(when,id, title,content);
  }

  Future<void> _scheduleNotification(DateTime scheduledNotificationDateTime,int id, String title, String content) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',vibrationPattern: vibrationPattern,
        importance: Importance.High, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        id,
        title,
        content,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}