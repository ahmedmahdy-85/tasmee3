class LocalTeacherModel {
  String name;
  String username;
  String id;
  String groupName;

  LocalTeacherModel({this.groupName, this.username, this.id, this.name});

  LocalTeacherModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    username = map['username'];
    id = map['id'];
    name = map['name'];
    groupName = map['groupName'];
  }

  toJson() {
    return {
      'username': username,
      'id': id,
      'name': name,
      'groupName': groupName,
    };
  }
}
