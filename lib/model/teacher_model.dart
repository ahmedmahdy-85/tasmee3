class TeacherModel {
  String name;
  String phone;
  String id;
  String username;
  String goal;
  String startOfGoal;
  String endOfGoal;
  String groupName;
  String token;
  int activeDay;

  TeacherModel(
      {this.goal,
      this.groupName,
      this.activeDay,
      this.endOfGoal,
      this.startOfGoal,
      this.username,
      this.name,
      this.id,
      this.token,
      this.phone});

  TeacherModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    username = map['username'];
    id = map['id'];
    phone = map['phone'];
    name = map['name'];
    goal = map['goal'];
    groupName = map['groupName'];
    token = map['token'];
    startOfGoal = map['startOfGoal'];
    endOfGoal = map['endOfGoal'];
    activeDay = map['activeDay'];
  }

  toJson() {
    return {
      'username': username,
      'id': id,
      'phone': phone,
      'name': name,
      'goal': goal,
      'groupName': groupName,
      'token': token,
      'startOfGoal': startOfGoal,
      'endOfGoal': endOfGoal,
      'activeDay': activeDay,
    };
  }
}
