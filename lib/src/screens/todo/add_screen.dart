import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/src/util/app_keys.dart';
import 'package:wishlist/src/util/style/app_theme.dart';
import 'package:wishlist/src/util/theme_provider.dart';
import 'package:wishlist/src/widgets/buttons/rounded_button.dart';
import 'package:wishlist/src/widgets/color_selector.dart';

class AddScreen extends StatefulWidget {
  final String todoId;

  AddScreen({
    Key key,
    this.todoId,
  }) : super(key: key ?? AppKeys.addTodoScreen);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TodoController _con = TodoController.con;
  String _title;
  String _content;
  int _category = 0;
  
  Color color;
  Color lastColor;
  AnimationController _animationController;
  Animation<Color> background;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      final themeProvider = Provider.of<ThemeProvider>(context);
      CardColors cardColors =
          themeProvider.isLightTheme ? CardLightColors() : CardDarkColors();
      color = cardColors.color0;
      setBackgroundColor(lastColor, color);
    }
    lastColor = color;
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Scaffold(
              backgroundColor: background.value,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Form(
                key: formKey,
                autovalidate: false,
                onWillPop: () {
                  return Future(() => true);
                },
                child: ListView(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildTitleFormFieled(),
                              Padding(padding: EdgeInsets.only(top: 8)),
                              ColorSelector(color,
                                  (index, color) {
                                this.color = color;
                                setBackgroundColor(lastColor, color);
                                _category = index;
                                _animationController.reset();
                                _animationController.forward();
                              }),
                              Padding(padding: EdgeInsets.only(top: 8)),
                              buildContentFormFieled(),
                            ])),
                  ],
                ),
              ),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(left: 32),
                child:
                    RoundedButton(AppLocalizations.of(context).tr('addtodo'), () {
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    _con.saveTodo(_title, _content, _category);
                    Navigator.pop(context);
                  }
                }, textColor: color, backgroundColor : Theme.of(context).primaryColorDark),
              ));
        });
  }

  Widget buildTitleFormFieled() {
    return TextFormField(
      initialValue: "",
      key: AppKeys.taskField,
      style: Theme.of(context).textTheme.headline,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).tr('newTodotite'),
          contentPadding: EdgeInsets.all(16),
          labelText: AppLocalizations.of(context).tr('todotite'),
          labelStyle: TextStyle(
              color:
                  Theme.of(context).textTheme.headline.color.withOpacity(0.5))),
      cursorColor: Theme.of(context).accentColor,
      onSaved: (value) => _title = value,
      validator: (String arg) {
        if (arg.length < 3)
          return AppLocalizations.of(context).tr('titletextmin');
        else
          return null;
      },
    );
  }

  Widget buildContentFormFieled() {
    return TextFormField(
      initialValue: '',
      key: AppKeys.noteField,
      maxLines: null,
      minLines: null,
      expands: false,
      style: Theme.of(context).textTheme.subhead,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).tr('contenttext'),
          contentPadding: EdgeInsets.all(16),
          labelText: AppLocalizations.of(context).tr('content'),
          labelStyle: TextStyle(
              fontSize: 21,
              color:
                  Theme.of(context).textTheme.headline.color.withOpacity(0.5))),
      cursorColor: Theme.of(context).accentColor,
      onSaved: (value) => _content = value,
    );
  }

  void setBackgroundColor(Color color1, Color color2) {
    background = ColorTween(
      begin: color1,
      end: color2,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }
}
