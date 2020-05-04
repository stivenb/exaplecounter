class UserData {
  String email;
  String password;
  String name;
  String userName;
  String token;

  UserData(String email, String password, String name, String token,
      String userName) {
    this.email = email;
    this.password = password;
    this.name = name;
    this.userName = userName;
    this.token = token;
  }

  UserData.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        name = json['name'],
        userName = json['username'],
        token = json['token'];
}
