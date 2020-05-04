import 'dart:convert';
import 'package:exaplecounter/Home.dart';
import 'package:exaplecounter/SignUp.dart';
import 'package:exaplecounter/user.dart';
import 'package:exaplecounter/userSession.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Sign In'),
      ),
      body: ListView(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: new InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: new InputDecoration(hintText: 'password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                )
              ])),
          Padding(
            padding: EdgeInsets.all(20),
            child: Consumer<UserSession>(
              builder: (context, usersession, child) => RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    signInAPI(emailController.text, passwordController.text)
                        .then((ret) {
                      if (ret != null) {
                        Provider.of<UserSession>(context, listen: false)
                            .createSession(ret.email, ret.password, ret.name,
                                ret.token, ret.userName);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => Home()));
                      }
                    });
                  }
                },
                child: new Text('Sign in'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => SignUp()));
              },
              child: Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
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
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Welcome to the jungle, we have got fun and games'),
        duration: Duration(seconds: 1),
      ));
      var data = jsonDecode(response.body);
      return new UserData(email, password,data['name'],data['token'],data['username']);
    } else {
      print("signup failed");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text('Sorry Bro you are not allowed to enter to the Jungle :('),
        duration: Duration(seconds: 1),
      ));
      return null;
    }
  }
}
