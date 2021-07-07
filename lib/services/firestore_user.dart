import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasmee3/model/progress_model.dart';
import 'package:tasmee3/model/student_model.dart';
import 'package:tasmee3/model/teacher_model.dart';
import 'package:tasmee3/model/user_model.dart';

class FireStoreUser {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');

  final CollectionReference _progressCollection =
      FirebaseFirestore.instance.collection('Progress');

  final CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection('Students');

  final CollectionReference _adminCollection =
      FirebaseFirestore.instance.collection('Admin');

  Future<void> addTeacher(String id, TeacherModel teacher) async {
    await _teachersCollection
        .doc(id)
        .collection('TeachersList')
        .doc(teacher.id)
        .set(teacher.toJson());
  }

  Future<void> addUserToFirestore(UserModel userModel) async {
    return await _usersCollection.doc(userModel.id).set(userModel.toJson());
  }

  Future<void> addProgressToFirestore(ProgressModel progress, String teacherId,
      String studentId, String id) async {
    return await _studentCollection
        .doc(teacherId)
        .collection('StudentsList')
        .doc(studentId)
        .collection('ProgressList')
        .doc(id)
        .set(progress.toJson());
  }

  Future<void> addStudentToFirestore(String id, StudentModel student) async {
    await _studentCollection
        .doc(id)
        .collection('StudentsList')
        .doc(student.id)
        .set(student.toJson());
  }

  Future<DocumentSnapshot> getAdminLogin() async {
    return await _adminCollection.doc('admin@123456').get();
  }

  Future<List<QueryDocumentSnapshot>> getSpecificUser(
    String username,
    String password,
  ) async {
    var result = await _usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();
    return result.docs;
  }

  Future<List<QueryDocumentSnapshot>> getLoginInfo(
    String username,
    String password,
  ) async {
    var result = await _usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();
    return result.docs;
  }

  Future<List<QueryDocumentSnapshot>> getStudentsOfTeacher(String id) async {
    return await _studentCollection
        .doc(id)
        .collection('StudentsList')
        .get()
        .then((value) {
      return value.docs;
    });
  }
}
