import 'package:easy_localization/easy_localization.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/src/screens/login/account_screen.dart';
import 'package:wishlist/src/screens/todo/edit_screen.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/src/screens/todo/add_screen.dart';
import 'package:wishlist/src/screens/settings/settings_screen.dart';
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
    _con.addNotificationListener((title, message) {
      print("itt" + title + " " + message);
      showFlushBar(title, message);
      _con.loadData();
    });
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final data = _con.list;
    final userData = _con.userData;
    return Scaffold(
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
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  expandedHeight: 100.0,
                  floating: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(AppLocalizations.of(context).tr('title'),
                          style: TextStyle(
                            fontSize: 18.0,
                          )),
                      background:
                          Container(color: Theme.of(context).primaryColor)),
                  actions: <Widget>[
                    IconButton(
                      icon: ClipRRect(
                          borderRadius: new BorderRadius.circular(16.0),
                          child: userData.photoUrl == ""
                              ? Icon(Icons.people)
                              : Image.network(
                                  userData.photoUrl,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
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
          body: RefreshIndicator(
              onRefresh: _con.loadData, child: buildList(data))),
    );
  }

  Widget buildList(var data) {
    if (data == null) return buildLoader(context);
    if (data.length == 0)
      return ListView(children: <Widget>[
        Center(child: Text(AppLocalizations.of(context).tr("nodata")))
      ]);
    return ListView(
      children: <Widget>[
        for (var d in data)
          Card(
              margin: EdgeInsets.all(16),
              child: ListTile(
                key: Key(d.id.toString()),
                title: Text(d.title),
                subtitle: Text(d.content),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    showModalBootomSheet(d);
                  },
                ),
                onLongPress: () {
                  showModalBootomSheet(d);
                },
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditScreen(d)));
                },
              ))
      ],
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
  }

  void showModalBootomSheet(d) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(left: 4, right: 4),
            color: Colors.transparent,
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                color: Theme.of(context).primaryColor,
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.notifications),
                        title: new Text('Notify'),
                        onTap: () {
                          _con.notifyTodo(d.title, d.content);
                          Navigator.pop(context);
                        }),
                    new ListTile(
                        leading: new Icon(Icons.edit),
                        title: new Text('Edit'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditScreen(d)));
                        }),
                    new ListTile(
                      leading: new Icon(Icons.delete),
                      title: new Text('Delete'),
                      onTap: () {
                        _con.deleteTodo(d.id);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
          );
        });
  }
}
