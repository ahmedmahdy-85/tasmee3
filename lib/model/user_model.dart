class UserModel {
  String name;
  String password;
  String username;
  bool isAdmin;
  bool isTeacher;
  String id;
  String teacherId;
  String comeFromAdmin;

  UserModel(
      {this.password,
      this.comeFromAdmin,
      this.teacherId,
      this.username,
      this.isAdmin,
      this.isTeacher,
      this.id,
      this.name});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    password = map['password'];
    username = map['username'];
    isAdmin = map['isAdmin'];
    isTeacher = map['isTeacher'];
    id = map['id'];
    name = map['name'];
    teacherId = map['teacherId'];
    comeFromAdmin = map['comeFromAdmin'];
  }

  toJson() {
    return {
      'password': password,
      'username': username,
      'isAdmin': isAdmin,
      'isTeacher': isTeacher,
      'id': id,
      'name': name,
      'teacherId': teacherId,
      'comeFromAdmin': comeFromAdmin,
    };
  }
}
