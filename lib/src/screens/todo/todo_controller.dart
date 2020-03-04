import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:wishlist/src/data/persistance/dao/alarm_dao.dart';
import 'package:wishlist/src/data/persistance/app_database.dart';
import 'package:wishlist/src/data/model/alarm_model.dart';
import 'package:wishlist/src/data/model/push_notification_model.dart';
import 'package:wishlist/src/data/model/user_model.dart';
import 'package:wishlist/src/networking/providers/notification_api_provider.dart';
import 'package:wishlist/src/networking/providers/todo_Api_provider.dart';
import 'package:wishlist/src/networking/request/todo_request.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/data/repository/session_repository.dart';
import 'package:wishlist/src/util/firebasenotifications.dart';
import 'package:wishlist/src/util/shared_prefs.dart';
import 'package:wishlist/src/util/alarm_manager.dart';

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
  List<int> order = [];

  final TodoApiProvider todoApiProvider = TodoApiProvider();
  final NotificationApiProvider notificationApiProvider =
      NotificationApiProvider();
  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();
  final AlarmDao _alarmDao = AlarmDao.instance;

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
    alarmIds = await _alarmDao.queryAlarmIds();
    order = await SharedPrefs.getOrderList();
    //print(order);
    list.sort((a, b) => order.indexOf(a.id).compareTo(order.indexOf(b.id)));
    //for (var l in list) print(l.id);
    refresh();
    return;
  }

  Future<void> saveTodo(String title, String content, int category) async {
    list = null;
    await todoApiProvider
        .addTodo(TodoRequest(
            title: title, content: content, userId: userData.userId, category: category))
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

  Future<void> update(
      int id, String title, String content, int category) async {
    list = null;
    await todoApiProvider
        .updateTodo(UpdateTodoRequest(
            id: id, title: title, content: content, category: category))
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

  Future<void> deleteAlarm(int id, VoidCallback callback) async {
    await cancelAlarm(id);
    await _deleteAlarmFromDb(id);
    refresh();
    callback();
  }

  Future<void> saveAlarm(DateTime when, int id, String title) async {
    AlarmModel alarm = AlarmModel(
        id: id,
        title: title,
        when: when.millisecondsSinceEpoch,
        alarmEnabled: true);
    await _alarmDao.insertAlarm(alarm);
  }

  Future<void> updateAlarm(DateTime when, int id, String title,
      {bool alarmEnabled = true}) async {
    AlarmModel alarm = AlarmModel(
        id: id,
        title: title,
        when: when.millisecondsSinceEpoch,
        alarmEnabled: alarmEnabled);
    await _alarmDao.updateAlarm(alarm);
  }

  Future<void> _deleteAlarmFromDb(int id) async {
    await _alarmDao.deleteAlarm(id);
  }

  Future<AlarmModel> existsAlarm(id) async {
    var alarm = await _alarmDao.queryAlarm(id);
    if (alarm == null) {
      print('read row $alarm: empty');
      return null;
    } else {
      print(
          'read row $alarm: ${alarm.title} ${alarm.when} ${alarm.alarmEnabled}');
      return alarm;
    }
  }

  void swapp(TodoResponse item, index) {
    int currentIndex = list.indexOf(item);
    list.remove(item);
    list.insert(currentIndex > index ? index : index - 1, item);
    refresh();
    var tmp = List<int>();
    for (var l in list) tmp.add(l.id);
    SharedPrefs.setOrderList(tmp);
  }

  Future<void> checkPermisison() async {
    await checkDrawOwerOtherAppsPermisison();
  }
}
