import 'dart:convert';
import 'package:exaplecounter/Home.dart';
import 'package:exaplecounter/SignUp.dart';
import 'package:exaplecounter/user.dart';
import 'package:exaplecounter/userSession.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String email = '';
  String token = '';
  String username = '';
  String password = '';
  String name = '';
  @override
  void initState() {
    super.initState();
    getlocalsession().then((ret) {
      if (ret != null) {
        signInAPI(email, password).then((ret2) {
          Provider.of<UserSession>(context, listen: false).createSession(
              ret2.email, ret2.password, ret2.name, ret2.token, ret2.userName);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSession>(
      builder: (context, usersession, child) =>
          _whatshow(usersession.mySession),
    );
  }

  Widget _whatshow(UserData session) {
    if (session == null) {
      return SignUp();
    } else {
      return Home();
    }
  }

  Future<UserData> getlocalsession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      try {
        email = prefs.getString('emailsess');
        name = prefs.getString('namesess');
        username = prefs.getString('usernamesess');
        token = prefs.getString('tokensess');
        password = prefs.getString('passwordsess');
        print('inicio');
        print('email: ' + email);
        print('username: ' + username);
        print('name: ' + name);
        print('password: ' + password);
        print('token: ' + token);
        print('fin');
      } catch (e) {}
    });
    if (email != null) {
      return new UserData(email, password, name, token, username);
    } else {
      return null;
    }
  }

  Future<UserData> signInAPI(String email, String password) async {
    final http.Response response = await http.post(
      'https://movil-api.herokuapp.com/signin',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return new UserData(
          email, password, data['name'], data['token'], data['username']);
    } else {
      print("signup failed");

      return null;
    }
  }
}
