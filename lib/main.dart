import 'package:exaplecounter/rootPage.dart';
import 'package:exaplecounter/userSession.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
      create: (context) => UserSession(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(),
    );
  }
}
