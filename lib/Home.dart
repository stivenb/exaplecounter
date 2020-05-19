import 'dart:convert';
import 'dart:io';

import 'package:exaplecounter/ViewCourse.dart';
import 'package:exaplecounter/rootPage.dart';
import 'package:exaplecounter/userSession.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'course.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String baseUrl = 'https://movil-api.herokuapp.com';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Course> myList;
  @override
  void initState() {
    super.initState();
    myList = new List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Home'),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: () {
                Provider.of<UserSession>(context, listen: false).closeSession();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => RootPage()));
              })
        ],
      ),
      floatingActionButton: Consumer<UserSession>(
        builder: (context, usersession, child) => new FloatingActionButton(
          onPressed: () {
            addCourseService(
                usersession.mySession.userName, usersession.mySession.token);
          },
          child: new Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<UserSession>(
          builder: (context, usersession, child) => new FutureBuilder(
                future: getCourses(usersession.mySession.userName,
                    usersession.mySession.token),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return _list();
                  } else {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  }
                },
              )),
    );
  }

  Widget _list() {
    return ListView.builder(
      itemCount: myList.length,
      itemBuilder: (context, index) {
        Course course = myList[index];
        return new ListTile(
          trailing: IconButton(
              icon: new Icon(Icons.chevron_right),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ViewCourse(info: course)));
              }),
          title: new Text(course.name),
          subtitle: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text('Profesor: ' + course.professor),
              new Text('Estudiantes: ' + course.students.toString())
            ],
          ),
        );
      },
    );
  }

  Future getCourses(String username, String token) async {
    Uri uri = Uri.https(
      "movil-api.herokuapp.com",
      '$username/courses',
    );
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + token,
      },
    );
    List<Course> couseList = [];
    print(
        'showCoursesService username $username token $token => ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (Map i in data) {
        couseList.add(Course.fromJson(i));
      }
    } else {
      print('Error');
      Provider.of<UserSession>(context, listen: false).closeSession();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => RootPage()));
    }
    setState(() {
      myList = couseList;
    });
    return couseList;
  }

  Future<Course> addCourseService(String username, String token) async {
    final http.Response response = await http.post(
      baseUrl + '/' + username + '/courses',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + token,
      },
    );
    print('token $token');
    print('${response.statusCode}');
    print(response.body);
    if (response.statusCode == 200) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Se ha añadido un curso satisfactoríamente'),
        duration: Duration(seconds: 2),
      ));
      setState(() {
        myList.add(Course.fromJson(json.decode(response.body)));
      });
      return Course.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Invalid token, closing session...'),
        duration: Duration(seconds: 1),
      ));
      await new Future.delayed(const Duration(seconds: 5));
      Provider.of<UserSession>(context, listen: false).closeSession();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => RootPage()));
    } else {
      Map<String, dynamic> body = json.decode(response.body);
      String error = body['error'];
      print('error  $error');
      return Future.error(error);
    }
  }
}
