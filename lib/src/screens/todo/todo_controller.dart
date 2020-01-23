import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:wishlist/src/datamodels/alarm_model.dart';
import 'package:wishlist/src/datamodels/push_notification_model.dart';
import 'package:wishlist/src/datamodels/user_model.dart';
import 'package:wishlist/src/networking/providers/notification_api_provider.dart';
import 'package:wishlist/src/networking/providers/todo_Api_provider.dart';
import 'package:wishlist/src/networking/request/todo_request.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/repository/session_repository.dart';
import 'package:wishlist/util/database_helper.dart';
import 'package:wishlist/util/firebasenotifications.dart';
import 'package:wishlist/util/shared_prefs.dart';
import 'package:wishlist/util/alarm_manager.dart';

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
  List<int> alarmIds;
  AlarmModel currentAlarm;

  final TodoApiProvider todoApiProvider = TodoApiProvider();
  final NotificationApiProvider notificationApiProvider =
      NotificationApiProvider();
  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();
  final DatabaseHelper helper = DatabaseHelper.instance;

  void init() async {
    _firebaseNotifications..setUpFirebase();
    userData = await SharedPrefs.getUserData();
    refresh();
    String firebaseDeviceId = await _firebaseNotifications.getToken();
    print(firebaseDeviceId);
    SessionRepository().setFirebaseDeviceId(firebaseDeviceId);
    registerForNotification(firebaseDeviceId, userData.userId);
    loadData();
  }

  Future<void> initAlarm(int id) async {
    currentAlarm = await existsAlarm(id);
    refresh();
  }

  Future<void> loadData() async {
    List<TodoResponse> resopnse =
        await todoApiProvider.getTodos().catchError((error) {
      throw error;
    });
    list = resopnse;
    alarmIds = await helper.queryAlarmIds();
    print(alarmIds);
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

  Future<void> insertOrUpdateAlarm(
      DateTime when, int id, String title, VoidCallback callback,
      {DatabaseActions action = DatabaseActions.insert}) async {
    await scheduleAlarm(when, id, title);
    switch (action) {
      case DatabaseActions.insert:
        await saveAlarm(when, id, title);
        alarmIds.add(id);
        refresh();
        break;
      case DatabaseActions.update:
        await updateAlarm(when, id, title);
        break;
    }
    callback();
  }

  Future<void> disableAlarm(
      DateTime when, int id, String title, VoidCallback callback,
      {DatabaseActions action = DatabaseActions.insert}) async {
    await cancelAlarm(id);
    await updateAlarm(when, id, title, alarmEnabled: false);
    refresh();
    callback();
  }

  Future<void> saveAlarm(DateTime when, int id, String title) async {
    AlarmModel alarm = AlarmModel(
        id: id,
        title: title,
        when: when.millisecondsSinceEpoch,
        alarmEnabled: true);
    await helper.insertAlarm(alarm);
  }

  Future<void> updateAlarm(DateTime when, int id, String title,
      {bool alarmEnabled = true}) async {
    AlarmModel alarm = AlarmModel(
        id: id,
        title: title,
        when: when.millisecondsSinceEpoch,
        alarmEnabled: alarmEnabled);
    await helper.updateAlarm(alarm);
  }

  Future<AlarmModel> existsAlarm(id) async {
    var alarm = await helper.queryAlarm(id);
    if (alarm == null) {
      print('read row $alarm: empty');
      return null;
    } else {
      print(
          'read row $alarm: ${alarm.title} ${alarm.when} ${alarm.alarmEnabled}');
      return alarm;
    }
  }
}
