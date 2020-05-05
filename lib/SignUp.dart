import 'dart:convert';
import 'package:exaplecounter/Login.dart';
import 'package:exaplecounter/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  List<UserData> allUsers = List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('SignUp'),
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
                ),
                new Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: nameController,
                    decoration: new InputDecoration(hintText: 'Name'),
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
                    controller: usernameController,
                    decoration: new InputDecoration(hintText: 'UserName'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ])),
          Padding(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  signUpAPI(emailController.text, passwordController.text,
                      usernameController.text, nameController.text);
                }
              },
              child: Text('Sign Up'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => Login()));
              },
              child: Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }
  Future signUpAPI(
      String email, String password, String username, String name) async {
    print(email);
    print(password);
    print(username);
    print(name);
    final http.Response response = await http.post(
      'https://movil-api.herokuapp.com/signup',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'username': username,
        'name': name
      }),
    );
    if (response.statusCode == 200) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('User Created'),
        duration: Duration(seconds: 1),
      ));
    } else {
      print("signup failed");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('SignUp failed, username/email already exist'),
        duration: Duration(seconds: 1),
      ));
      print('${response.body}');
      throw Exception(response.body);
    }
  }
}
