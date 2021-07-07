import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/pages/authentication/login_page.dart';
import 'package:tasmee3/view_model/control_view_model.dart';

class ProfileViewModel extends GetxController {
  String name, userId, username, password, groupName, teacherId;
  bool isAdmin, isTeacher;
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');
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
  TextEditingController groupNameController = TextEditingController();
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
        isTeacher = true;
        teacherId = value.teacherId;
      }
    });
    _loading.value = false;
    update();
  }

  void signOut() async {
    await localStorageData.deleteUser();
    Get.find<ControlViewModel>().teacherChangeSelectedValue(0);
    update();
    Get.offAll(() => LoginScreen());
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
      await _teachersCollection
          .doc('admin@123456')
          .collection('TeachersList')
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
          isTeacher: true,
          isAdmin: false,
          teacherId: userId);
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
          isTeacher: true,
          isAdmin: false,
          teacherId: userId));
      globalKey.currentState.showSnackBar(snackBar2);
    }
    passwordController.clear();
    _loading.value = false;
    update();
  }

  Future<void> updateGroupName() async {
    _loading.value = true;
    await getCurrentUserData();
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(userId)
        .get()
        .then((value) async {
      if (value.exists) {
        await value.reference.update({'groupName': groupNameController.text});
      }
    });
    await _studentsCollection
        .doc(userId)
        .collection('StudentsList')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                await element.reference
                    .update({'groupName': groupNameController.text});
              })
            });
    globalKey.currentState.showSnackBar(snackBar2);
    groupNameController.clear();
    _loading.value = false;
    update();
  }
}
