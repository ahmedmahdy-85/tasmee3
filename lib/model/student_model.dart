class StudentModel implements Comparable<StudentModel> {
  String name;
  String username;
  String phone;
  String goal;
  String id;
  String uncompleteTasmee3Details;
  String startOfGoal;
  String endOfGoal;
  bool isActive;
  String groupName;
  String teacherId;
  String status;
  int activationDay;
  String uncompleteTasmee3Date;

  @override
  int compareTo(StudentModel other) {
    if (name.trim().compareTo(other.name.trim()) < 1) {
      return -1;
    } else if (name.trim().compareTo(other.name.trim()) == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  StudentModel({
    this.name,
    this.uncompleteTasmee3Date,
    this.status,
    this.activationDay,
    this.teacherId,
    this.groupName,
    this.isActive,
    this.startOfGoal,
    this.endOfGoal,
    this.goal,
    this.username,
    this.uncompleteTasmee3Details,
    this.phone,
    this.id,
  });

  StudentModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    name = map['name'];
    phone = map['phoneNum'];
    username = map['username'];
    goal = map['goal'];
    uncompleteTasmee3Details = map['uncompleteTasmee3Details'];
    groupName = map['groupName'];
    isActive = map['isActive'];
    teacherId = map['teacherId'];
    status = map['status'];
    activationDay = map['activationDay'];
    uncompleteTasmee3Date = map['uncompleteTasmee3Date'];
    startOfGoal = map['startOfGoal'];
    endOfGoal = map['endOfGoal'];
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'userName': username,
      'goal': goal,
      'uncompleteTasmee3Details': uncompleteTasmee3Details,
      'groupName': groupName,
      'isActive': isActive,
      'teacherId': teacherId,
      'status': status,
      'activationDay': activationDay,
      'uncompleteTasmee3Date': uncompleteTasmee3Date,
      'startOfGoal': startOfGoal,
      'endOfGoal': endOfGoal,
    };
  }
}
