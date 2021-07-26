import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel implements Comparable<ProgressModel> {
  String status;
  String studentName;
  String date;
  int complete;
  int uncomplete;
  int noTasmee3;
  int day;
  int month;
  int year;
  int completeWithPunish;
  String uncompleteTasmee3Details;

  ProgressModel(
      {this.studentName,
      this.completeWithPunish,
      this.status,
      this.noTasmee3,
      this.uncomplete,
      this.uncompleteTasmee3Details,
      this.date,
      this.complete,
      this.day,
      this.month,
      this.year});

  @override
  int compareTo(ProgressModel other) {
    if (studentName.trim().compareTo(other.studentName.trim()) < 1) {
      return -1;
    } else if (studentName.trim().compareTo(other.studentName.trim()) == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  ProgressModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    status = map['status'];
    studentName = map['studentName'];
    noTasmee3 = map['noTasmee3'];
    complete = map['complete'];
    uncomplete = map['uncomplete'];
    completeWithPunish = map['completeWithPunish'];
    date = map['date'];
    day = map['day'];
    month = map['month'];
    year = map['year'];
    uncompleteTasmee3Details = map['uncompletDetails'];
  }

  toJson() {
    return {
      'status': status,
      'studentName': studentName,
      'noTasmee3': noTasmee3,
      'complete': complete,
      'uncomplete': uncomplete,
      'completeWithPunish': completeWithPunish,
      'date': date,
      'day': day,
      'month': month,
      'year': year,
      'uncompletDetails': uncompleteTasmee3Details,
    };
  }
}
