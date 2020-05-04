import 'package:exaplecounter/rootPage.dart';
import 'package:exaplecounter/userSession.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer<UserSession>(
            builder: (context, usersession, child) =>
                new Text('Email: ${usersession.mySession.email}'),
          ),
          Consumer<UserSession>(
            builder: (context, usersession, child) =>
                new Text('Name: ${usersession.mySession.name}'),
          ),
          Consumer<UserSession>(
            builder: (context, usersession, child) =>
                new Text('UserName: ${usersession.mySession.userName}'),
          ),
          RaisedButton(
            onPressed: () {
              Provider.of<UserSession>(context, listen: false).closeSession();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => RootPage()));
            },
            child: new Text('Cerrar sesion'),
          )
        ],
      ),
    );
  }
}
