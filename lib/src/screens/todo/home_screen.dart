import 'package:easy_localization/easy_localization.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:wishlist/src/database/database_helper.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/screens/login/account_screen.dart';
import 'package:wishlist/src/screens/todo/edit_screen.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/src/screens/todo/add_screen.dart';
import 'package:wishlist/src/screens/settings/settings_screen.dart';
import 'package:wishlist/util/alert_dialog.dart';
import 'package:wishlist/util/app_theme.dart';
import 'package:wishlist/util/theme_provider.dart';
import 'package:wishlist/util/widgets.dart';

class HomeScreen extends StatefulWidget {
  @protected
  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController _con = TodoController.con;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @protected
  @override
  void initState() {
    super.initState();

    /// Calls the Controller when this one-time 'init' event occurs.
    /// Not revealing the 'business logic' that then fires inside.
    _con.init();
    _con.addNotificationListener((data) {
      print(
          "itt" + data.title + " " + data.content + " " + data.type.toString());
      showFlushBar(data.title, data.content);
      _con.loadData();
    });
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final data = _con.list;
    final userData = _con.userData;
    final alarmIds = _con.alarmIds;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldKey,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddScreen()))
            },
          ),
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      floating: false,
                      pinned: true,
                      bottom: buildTabBar(),
                      backgroundColor: Colors.transparent,
                      title: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(AppLocalizations.of(context).tr('title'),
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w800))),
                      actions: <Widget>[
                        IconButton(
                          icon: ClipRRect(
                              borderRadius: new BorderRadius.circular(16.0),
                              child: userData == null
                                  ? Icon(Icons.people)
                                  : Image.network(
                                      userData.photoUrl,
                                      fit: BoxFit.contain,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    )),
                          tooltip: 'Add new entry',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountScreen()));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          tooltip: 'Add new entry',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsScreen()));
                          },
                        ),
                      ]),
                ];
              },
              body: TabBarView(children: [
                RefreshIndicator(
                    onRefresh: _con.loadData, child: buildList(data, alarmIds)),
                Center(child: Text("TODO"))
              ])),
        ));
  }

  Widget buildList(var data, List<int> alarmIds) {
    if (data == null) return buildLoader(context);
    if (data.length == 0)
      return ListView(children: <Widget>[
        Center(child: Text(AppLocalizations.of(context).tr("nodata")))
      ]);
    final themeProvider = Provider.of<ThemeProvider>(context);
    CardColors cardColors =
        themeProvider.isLightTheme ? CardLightColors() : CardDarkColors();
    return StaggeredGridView.count(
      crossAxisCount: 4,
      children: <Widget>[
        for (var i = 0; i < data.length; i++)
          buildGridItem(i, data[i], cardColors, alarmIds.contains(data[i].id))
      ],
      //Do you need to go somewhere when you tap on this card, wrap using InkWell and add your route
      staggeredTiles:
          data.map<StaggeredTile>((item) => StaggeredTile.fit(2)).toList(),
    );
  }

  void showFlushBar(String title, String message) {
    Flushbar(
      titleText: Text(title),
      messageText: Text(message),
      backgroundColor: Theme.of(context).primaryColorLight,
      icon: Icon(Icons.notifications_active),
      duration: Duration(seconds: 3),
    )..show(context);
    FlutterRingtonePlayer.playNotification(looping: false);
  }

  void showModalBootomSheet(d, CardColors cardColors, bool hasAlarm) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(left: 4, right: 4),
            color: Colors.transparent,
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0))),
                color: Theme.of(context).primaryColor,
                child: new Wrap(
                  children: <Widget>[
                    Container(
                      height: 8,
                    ),
                    Center(
                        child: Container(
                      decoration: BoxDecoration(
                          color: themeProvider.isLightTheme
                              ? Colors.grey[500]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(4.0)),
                      width: 40,
                      height: 4,
                    )),
                    buildCategoryItem(
                      cardColors.color0,
                      AppLocalizations.of(context).tr('bottom_sheet_nocat'),
                      d.id,
                      0,
                    ),
                    buildCategoryItem(
                      cardColors.color1,
                      AppLocalizations.of(context).tr('bottom_sheet_normal'),
                      d.id,
                      1,
                    ),
                    buildCategoryItem(
                      cardColors.color2,
                      AppLocalizations.of(context).tr('bottom_sheet_lesimp'),
                      d.id,
                      2,
                    ),
                    buildCategoryItem(
                      cardColors.color3,
                      AppLocalizations.of(context).tr('bottom_sheet_imp'),
                      d.id,
                      3,
                    ),
                    new ListTile(
                        leading: new Icon(Icons.notifications),
                        title: new Text(AppLocalizations.of(context)
                            .tr('bottom_sheet_notif')),
                        onTap: () {
                          _con.notifyTodo(d.title, d.content);
                          Navigator.pop(context);
                        }),
                    new ListTile(
                        leading: new Icon(Icons.alarm_add),
                        title: hasAlarm
                            ? Text(AppLocalizations.of(context)
                                .tr('bottom_sheet_updatealarm'))
                            : Text(AppLocalizations.of(context)
                                .tr('bottom_sheet_setdatealarm')),
                        onTap: () async {
                          Navigator.pop(context);
                          showTimePickerDialog(
                              context,
                              AppLocalizations.of(context)
                                  .tr('dialog_timepicker_title'),
                              (dateTime) async {
                            showLoaderDialog(context);
                            await _con.insertOrUpdateAlarm(
                                dateTime, d.id, d.title, () {
                              Navigator.pop(context);
                            },
                                action: hasAlarm
                                    ? DatabaseActions.update
                                    : DatabaseActions.insert);
                          });
                        }),
                    new ListTile(
                        leading: new Icon(Icons.edit),
                        title: new Text(AppLocalizations.of(context)
                            .tr('bottom_sheet_edit')),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditScreen(d)));
                        }),
                    new ListTile(
                      leading: new Icon(Icons.delete),
                      title: new Text(AppLocalizations.of(context)
                          .tr('bottom_sheet_delete')),
                      onTap: () {
                        _con.deleteTodo(d.id);
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    )
                  ],
                )),
          );
        });
  }

  buildGridItem(index, d, cardColors, bool hasAlarm) {
    var color = CardColors.colorSelector(d.category, cardColors);
    var item = Padding(
        padding: EdgeInsets.all(4),
        child: Container(
            child: Card(
                color: color,
                child: ListTile(
                  key: Key(d.id.toString()),
                  title: Container(
                      height: 40,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(d.title.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700),)),
                  subtitle: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(d.content, overflow: TextOverflow.fade)),
                  trailing: IconButton(
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.topRight,
                    icon: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                          if (hasAlarm) Icon(Icons.alarm),
                          Icon(Icons.more_vert)
                        ])),
                    onPressed: () {
                      showModalBootomSheet(d, cardColors, hasAlarm);
                    },
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditScreen(d, color: color)));
                  },
                ))));
    Draggable draggable = LongPressDraggable<TodoResponse>(
      data: d,
      maxSimultaneousDrags: 1,
      child: item,
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: item,
      ),
      feedback: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
        child: item,
      ),
    );
    return DragTarget<TodoResponse>(
      onWillAccept: (track) {
        return _con.list.indexOf(track) != index;
      },
      onAccept: (track) {
        _con.swapp(track, index);
      },
      builder: (BuildContext context, List<TodoResponse> candidateData,
          List<dynamic> rejectedData) {
        return Column(
          children: <Widget>[
            candidateData.isEmpty ? Container() : Container(height: 30),
            candidateData.isEmpty ? draggable : item,
          ],
        );
      },
    );
  }

  buildCategoryItem(color, text, id, category) {
    return ListTile(
        leading: Icon(
          Icons.fiber_manual_record,
          color: color,
        ),
        title: Text(text),
        onTap: () {
          _con.updateCategory(id, category);
          Navigator.pop(context);
        });
  }

  buildTabBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Row(children: <Widget>[
          TabBar(
              isScrollable: true,
              unselectedLabelColor:
                  Theme.of(context).primaryColorDark.withOpacity(0.5),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: UnderlineIndicator(
                strokeCap: StrokeCap.round,
                borderSide: BorderSide(
                  width: 4,
                  color: Theme.of(context).primaryColorDark,
                ),
                insets: EdgeInsets.only(left: 0, right: 0, bottom: 6),
              ),
              tabs: [
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Active",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Archived",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ])
        ]));
  }
}
