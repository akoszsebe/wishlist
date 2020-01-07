import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/src/todo_controller.dart';
import 'package:wishlist/src/screens/add_screen.dart';
import 'package:wishlist/src/screens/theme_change_screen.dart';
import 'package:wishlist/util/alert_dialog.dart';
import 'package:wishlist/util/widgets.dart';

class HomeScreen extends StatefulWidget {
  @protected
  @override
  createState() => HomeView();
}

class HomeView extends State<HomeScreen> {
  final TodoController _con = TodoController.con;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @protected
  @override
  void initState() {
    super.initState();

    /// Calls the Controller when this one-time 'init' event occurs.
    /// Not revealing the 'business logic' that then fires inside.
    _con.init();
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final data = _con.list;
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
                      icon: const Icon(Icons.settings),
                      tooltip: 'Add new entry',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ThemeChangerScreen()));
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
                trailing: Icon(Icons.more_vert),
                onLongPress: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          color: Theme.of(context).primaryColor,
                          child: new Wrap(
                            children: <Widget>[
                              new ListTile(
                                  leading: new Icon(Icons.notifications),
                                  title: new Text('Notify'),
                                  onTap: () => {}),
                              new ListTile(
                                  leading: new Icon(Icons.edit),
                                  title: new Text('Edit'),
                                  onTap: () => {}),
                              new ListTile(
                                leading: new Icon(Icons.delete),
                                title: new Text('Delete'),
                                onTap: () { _con.deleteTodo(d.id); Navigator.pop(context);},
                              ),
                            ],
                          ),
                        );
                      });
                },
                onTap: () => {
                  showAlertDialog(
                      context, "Item", "content", () => {}, () => {})
                },
              ))
      ],
    );
  }
}
