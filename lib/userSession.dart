import 'package:exaplecounter/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession with ChangeNotifier {
  UserData mySession;

  void createSession(String email, String password, String name, String token,
      String userName) {
    mySession = new UserData(email, password, name, token, userName);
    saveSession(mySession);
    notifyListeners();
  }
  void createSession2(String email, String password, String name, String token,
      String userName) {
    mySession = new UserData(email, password, name, token, userName);
    notifyListeners();
  }
  void closeSession() {
    mySession = null;
    deleteSession();
    notifyListeners();
  }

  saveSession(UserData userS) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('emailsess', userS.email);
    prefs.setString('passwordsess', userS.password);
    prefs.setString('tokensess', userS.token);
    prefs.setString('namesess', userS.name);
    prefs.setString('usernamesess', userS.userName);
  }

  deleteSession() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('emailsess');
    prefs.remove('passwordsess');
    prefs.remove('tokensess');
    prefs.remove('namesess',);
    prefs.remove('usernamesess');
  }
}
