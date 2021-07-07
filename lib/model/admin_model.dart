class AdminModel {
  String name;
  String password;
  String username;
  String id;
  String phone;
  bool isActive;

  AdminModel(
      {this.id,
      this.name,
      this.password,
      this.username,
      this.phone,
      this.isActive});

  AdminModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    password = map['password'];
    name = map['name'];
    phone = map['phoneNum'];
    username = map['username'];
    isActive = map['isActive'];
  }

  toJson() {
    return {
      'id': id,
      'password': password,
      'name': name,
      'phone': phone,
      'userName': username,
      'isActive': isActive,
    };
  }
}
