import 'dart:convert';
import 'dart:io';
import 'package:exaplecounter/ViewProfessor.dart';
import 'package:exaplecounter/ViewStudent.dart';
import 'package:exaplecounter/course.dart';
import 'package:exaplecounter/rootPage.dart';
import 'package:exaplecounter/userSession.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'course_detail.dart';

class ViewCourse extends StatefulWidget {
  final Course info;
  ViewCourse({Key key, this.info}) : super(key: key);

  @override
  _ViewCourseState createState() => _ViewCourseState();
}

class _ViewCourseState extends State<ViewCourse> {
  List<Widget> commentWidgets;
  CourseDetail myDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    myDetails = null;
    super.initState();
    commentWidgets = List<Widget>();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.all(12),
            child: _generalInfo(widget.info),
          ),
          Consumer<UserSession>(
              builder: (context, usersession, child) => new FutureBuilder(
                    future: students(usersession.mySession.userName,
                        usersession.mySession.token, widget.info.id),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        CourseDetail course = snapshot.data;
                        return new Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: course.students.length,
                            itemBuilder: (context, index) {
                              return new ListTile(
                                trailing: new IconButton(
                                    icon: new Icon(Icons.keyboard_arrow_right),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ViewStudent(
                                                      info: course
                                                          .students[index])));
                                    }),
                                title: new Text(course.students[index].name),
                                subtitle: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text('UserName: ' +
                                        course.students[index].username),
                                    new Text('Email: ' +
                                        course.students[index].email)
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return new Center(
                          child: new CircularProgressIndicator(),
                        );
                      }
                    },
                  )),
        ],
      ),
    );
  }

  Widget _generalInfo(Course course) {
    if (myDetails != null) {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'Curso: ' + myDetails.name,
            style: new TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          new Text(
            'Course Id: ' + course.id.toString(),
            style: new TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          new Row(
            children: <Widget>[
              new Text(
                'Profesor: ' + myDetails.professor.name,
                style: new TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new IconButton(
                  icon: new Icon(Icons.view_headline),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ViewProfessor(
                              info: myDetails.professor,
                            )));
                  })
            ],
          ),
        ],
      );
    } else {
      return new Text('');
    }
  }

  Future<CourseDetail> students(
      String username, String token, int courseId) async {
    Uri uri = Uri.https(
      "movil-api.herokuapp.com",
      '$username/courses/$courseId',
    );
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + token,
      },
    );
    print(
        'getCourse username $username token $token => ${response.statusCode}');
    print(response.body);
    if (response.statusCode == 200) {
      CourseDetail detail = CourseDetail.fromJson(json.decode(response.body));
      if (this.mounted) {
        setState(() {
          myDetails = detail;
        });
      }
      return detail;
    } else if (response.statusCode == 401) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Invalid token, closing session...'),
        duration: Duration(seconds: 1),
      ));
      await new Future.delayed(const Duration(seconds: 5));
      Provider.of<UserSession>(context, listen: false).closeSession();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => RootPage()));
      return null;
    } else {
      return null;
    }
  }
}
