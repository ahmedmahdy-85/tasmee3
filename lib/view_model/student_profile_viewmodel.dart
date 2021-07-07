import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/pages/authentication/login_page.dart';
import 'package:tasmee3/view_model/control_view_model.dart';

class StudentProfileViewModel extends GetxController {
  String name, userId, username, password, groupName, teacherId;
  bool isAdmin, isTeacher;
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  final snackBar = SnackBar(
    content: Text(
      'لا يوجد اتصال بالانترنت',
      style: TextStyle(fontSize: 16.0),
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  final snackBar2 = SnackBar(
    content: Text(
      'تم تعديل البيانات بنجاح',
      style: TextStyle(fontSize: 16.0),
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool validName = true;
  bool validPassword = true;
  LocalStorageData localStorageData = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> getCurrentUserData() async {
    _loading.value = true;
    await localStorageData.getUser.then((value) {
      if (value != null) {
        userId = value.id;
        username = value.username;
        name = value.name;
        password = value.password;
        isAdmin = false;
        isTeacher = false;
        teacherId = value.teacherId;
      }
    });
    _loading.value = false;
    update();
  }

  void signOut() async {
    _loading.value = true;
    await localStorageData.deleteUser();
    Get.find<ControlViewModel>().studentChangeSelectedValue(0);
    _loading.value = false;
    update();
    Get.offAll(() => LoginScreen(),
        transition: Transition.leftToRight, duration: Duration(seconds: 0));
  }

  Future<void> updateName() async {
    _loading.value = true;
    validName = nameController.text.trim().length < 3 ? false : true;
    if (validName) {
      await getCurrentUserData();
      await _usersCollection.doc(userId).get().then((value) async {
        if (value.exists) {
          await value.reference.update({'name': nameController.text});
        }
      });
      await _studentsCollection
          .doc(teacherId)
          .collection('StudentsList')
          .doc(userId)
          .get()
          .then((value) async {
        if (value.exists) {
          await value.reference.update({'name': nameController.text});
        }
      });
      UserModel newUser = UserModel(
          name: nameController.text,
          password: password,
          username: username,
          id: userId,
          isTeacher: false,
          isAdmin: false,
          teacherId: teacherId);
      await localStorageData.setUser(newUser);
      globalKey.currentState.showSnackBar(snackBar2);
    }
    nameController.clear();
    _loading.value = false;
    update();
  }

  Future<void> updatePassword() async {
    _loading.value = true;
    validPassword = passwordController.text.trim().length < 6 ? false : true;
    if (validPassword) {
      await getCurrentUserData();
      await _usersCollection.doc(userId).get().then((value) async {
        if (value.exists) {
          await value.reference.update({'password': passwordController.text});
        }
      });
      await localStorageData.setUser(UserModel(
          name: name,
          password: passwordController.text,
          username: username,
          id: userId,
          isTeacher: false,
          isAdmin: false,
          teacherId: teacherId));
      globalKey.currentState.showSnackBar(snackBar2);
    }
    passwordController.clear();
    _loading.value = false;
    update();
  }
}
