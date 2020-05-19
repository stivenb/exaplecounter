class StudentDetail {
  int id;
  String name;
  String username;
  String phone;
  String email;
  String city;
  String country;

  StudentDetail(
      {this.id,
      this.name,
      this.username,
      this.phone,
      this.email,
      this.city,
      this.country});

  StudentDetail.initial()
      : id = 0,
        name = '',
        username = '',
        phone = '',
        email = '',
        city = '',
        country = '';
  StudentDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username =json['username'];
    phone= json['phone'];
    email = json['email'];
    city = json['city'];
    country = json['country'];
  }
}
