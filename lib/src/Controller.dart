import 'package:mvc_pattern/mvc_pattern.dart';

class Con extends ControllerMVC {
  factory Con() {
    if (_this == null) _this = Con._();
    return _this;
  }
  static Con _this;

  Con._();

  static Con get con => _this;

  void init() => loadData();

    Future loadData() async {
    var load = "";// await model.loadTodos();
    // In this case, it is the Controller that decides to 'refresh' the View.
    refresh();
    return load;
  }
}