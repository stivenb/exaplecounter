import 'dart:convert';
import 'dart:io';

import 'package:exaplecounter/person.dart';
import 'package:exaplecounter/rootPage.dart';
import 'package:exaplecounter/student_detail.dart';
import 'package:exaplecounter/userSession.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ViewProfessor extends StatefulWidget {
  final Person info;
  ViewProfessor({Key key, this.info}) : super(key: key);

  @override
  _ViewProfessorState createState() => _ViewProfessorState();
}

class _ViewProfessorState extends State<ViewProfessor> {
  StudentDetail detailStudent;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Consumer<UserSession>(
          builder: (context, usersession, child) => new FutureBuilder(
                future: professorDetail(usersession.mySession.userName,
                    usersession.mySession.token, widget.info.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    StudentDetail details = snapshot.data;
                    return new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          'Nombre: ' + details.name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        new Text('User name: ' + details.username),
                        new Text('Telefono: ' + details.phone),
                        new Text('E-mail: ' + details.email),
                        new Text('Ciudad: ' + details.city),
                        new Text('Pais: ' + details.country),
                      ],
                    );
                  } else {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  }
                },
              )),
    );
  }

  Future<StudentDetail> professorDetail(
      String username, String token, int studentId) async {
    Uri uri = Uri.https(
      "movil-api.herokuapp.com",
      '$username/students/$studentId',
    );

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + token,
      },
    );
    if (response.statusCode == 200) {
      StudentDetail detail = StudentDetail.fromJson(json.decode(response.body));
      print(detail);
      return detail;
    } else if (response.statusCode == 403) {
      return null;
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
