import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/src/Controller.dart';
import 'package:wishlist/src/screens/add_screen.dart';
import 'package:wishlist/util/alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  @protected
  @override
  createState() => HomeView();
}

class HomeView extends State<HomeScreen> {
  final Con _con = Con.con;

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(AppLocalizations.of(context).tr('title'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                    background:
                        Container(color: Theme.of(context).primaryColor)),
              ),
            ];
          },
          body: ListView(
            children: <Widget>[
              Card(
                  margin: EdgeInsets.all(16),
                  child: ListTile(
                    title: Text("vegyel tusfurdot"),
                    subtitle: Text("1 liter"),
                     trailing: Icon(Icons.more_vert),
                     onTap: ()=>{
                       showAlertDialog(context,"Item","content",()=>{},()=>{})
                     },
                  ))
            ],
          )),
    );
  }
}
