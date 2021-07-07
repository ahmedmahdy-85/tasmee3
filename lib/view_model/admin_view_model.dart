import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/local_teachers_model.dart';
import 'package:tasmee3/model/teacher_model.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/pages/control_view.dart';
import 'package:tasmee3/services/firestore_user.dart';
import 'package:tasmee3/services/sqlflite_db.dart';
import 'package:tasmee3/view_model/control_view_model.dart';
import 'package:tasmee3/widgets/custom_text.dart';
import 'package:uuid/uuid.dart';

class AdminViewModel extends GetxController {
  int i;
  String teacherId;
  bool deletable = false;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  final snackBar2 = SnackBar(
    content: Text(
      'لا يوجد اتصال بالانترنت',
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  var dbHelper = AdminDatabaseHelper.db;
  LocalStorageData localStorageData = Get.find();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  String id = Uuid().v4();
  TextEditingController groupNameController = TextEditingController();
  String registerUserName, registerName, registerPassword, phoneNum;
  bool registerVal = true;
  List<String> signUpErrors = [];
  List<LocalTeacherModel> _users = [];
  List<LocalTeacherModel> get users => _users;
  List<String> ids = [];

  void onInit() async {
    super.onInit();
    await fillLocalDb();
    await getAllUsers();
  }

  Future<void> teacherDelegation(String id) async {
    _loading.value = true;
    await dbHelper.getUser(id).then((value) async {
      UserModel user = UserModel(
        name: value.name,
        id: value.id,
        username: value.username,
        comeFromAdmin: 'true',
        isTeacher: true,
        isAdmin: false,
      );
      await saveUserToSharedPref(user);
      Get.find<ControlViewModel>().setSavedUser(user);
    });
    _loading.value = false;
    update();
    Get.offAll(() => ControlView());
  }

  void setLoading() {
    _loading.value = !_loading.value;
    update();
  }

  Future<void> getAllUsers() async {
    _loading.value = true;
    _users = await dbHelper.getAllUsers();
    _loading.value = false;
    update();
  }

  void hideRegisterVal() {
    registerVal = !registerVal;
    update();
  }

  void registerOnSaved(int values, String value) {
    if (values == 0) {
      registerPassword = value;
      update();
    }
    if (values == 1) {
      registerName = value;
      update();
    }
    if (values == 2) {
      registerUserName = value;
      update();
    }
  }

  void registerOnChanged(String value, int values) {
    if (value.isNotEmpty &&
        signUpErrors.contains('من فضلك اكمل البيانات الخاصة بك')) {
      signUpErrors.remove('من فضلك اكمل البيانات الخاصة بك');
      update();
    }
    if (values == 0) {
      if (value.length >= 6 &&
          signUpErrors.contains('الرقم السري يجب ان لا يقل عن ستة احرف')) {
        signUpErrors.remove('الرقم السري يجب ان لا يقل عن ستة احرف');
        update();
      }
    }
    if (values == 1) {
      if (value.length >= 3 &&
          signUpErrors.contains("من فضلك تاكد ان الاسم لا يقل عن ثلاثة احرف")) {
        signUpErrors.remove("من فضلك تاكد ان الاسم لا يقل عن ثلاثة احرف");
        update();
      }
    }
    if (values == 2) {
      if (value.length >= 8 &&
          signUpErrors.contains("اسم المستخدم يجب الا يقل عن ثمانية ارقام")) {
        signUpErrors.remove("اسم المستخدم يجب الا يقل عن ثمانية ارقام");
        update();
      }
    }
  }

  void registerValidator(String value, int values) {
    if (value.isEmpty &&
        !signUpErrors.contains('من فضلك اكمل البيانات الخاصة بك')) {
      signUpErrors.add('من فضلك اكمل البيانات الخاصة بك');
      update();
    }
    if (values == 0) {
      if ((value.length < 6 && value.length != 0) &&
          !signUpErrors.contains('الرقم السري يجب ان لا يقل عن ستة احرف')) {
        signUpErrors.add('الرقم السري يجب ان لا يقل عن ستة احرف');
        update();
      }
    }

    if (values == 1) {
      if (value.length < 3 &&
          value.length != 0 &&
          !signUpErrors
              .contains('من فضلك تاكد ان الاسم لا يقل عن ثلاثة احرف')) {
        signUpErrors.add('من فضلك تاكد ان الاسم لا يقل عن ثلاثة احرف');
        update();
      }
    }
    if (values == 2) {
      if (value.length < 8 &&
          value.length != 0 &&
          !signUpErrors.contains("اسم المستخدم يجب الا يقل عن ثمانية ارقام")) {
        signUpErrors.add("اسم المستخدم يجب الا يقل عن ثمانية ارقام");
        update();
      }
    }
  }

  Future<void> saveUserToSharedPref(UserModel userModel) async {
    await localStorageData.setUser(userModel);
    update();
  }

  Future<void> signUp(BuildContext context) async {
    setLoading();
    await FireStoreUser()
        .getSpecificUser(
      registerUserName.replaceAll(new RegExp(r"\s+"), ""),
      registerPassword,
    )
        .then((value) async {
      if (value.isNotEmpty) {
        groupNameController.clear();
        setLoading();
        final snackBar = SnackBar(
          content: Text(
            'هذا الحساب تم تسجيله من قبل',
            textDirection: TextDirection.rtl,
          ),
          duration: Duration(seconds: 4),
        );
        globalKey.currentState.showSnackBar(snackBar);
        return;
      } else {
        UserModel user = UserModel(
            name: registerName,
            username: registerUserName,
            password: registerPassword,
            id: id,
            comeFromAdmin: 'false',
            teacherId: id,
            isTeacher: true,
            isAdmin: false);
        await FireStoreUser().addUserToFirestore(user);
        LocalTeacherModel localTeacherModel = LocalTeacherModel(
            name: user.name,
            groupName: groupNameController.text,
            id: user.id,
            username: user.username);
        _users.add(localTeacherModel);
        await FireStoreUser().addTeacher(
            'admin@123456',
            TeacherModel(
                name: registerName,
                startOfGoal: '',
                endOfGoal: '',
                username: registerUserName,
                id: user.id,
                token: '',
                groupName: groupNameController.text,
                goal: '',
                phone: registerUserName));
        id = Uuid().v4();
        groupNameController.clear();
        _loading.value = false;
        update();
        Get.back();
      }
    });
  }

  Future<void> fillLocalDb() async {
    _loading.value = true;
    await dbHelper.cleanDb();
    dbHelper = AdminDatabaseHelper.db;
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .get()
        .then((value) {
      value.docs.forEach((doc) async {
        LocalTeacherModel localTeacherModel = LocalTeacherModel(
            name: doc.get('name'),
            username: doc.get('username'),
            groupName: doc.get('groupName'),
            id: doc.get('id'));
        await dbHelper.insertUser(localTeacherModel);
      });
    });
    _loading.value = false;
    update();
  }

  Future<void> deleteGroup(
    String teacherId,
  ) async {
    await _usersCollection.doc(teacherId).delete();
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await _usersCollection.doc(element.reference.id).delete();
      });
    });
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(teacherId)
        .delete();
    await _studentsCollection.doc(teacherId).delete();
    _users.removeWhere((element) => element.id == teacherId);
    i = 100000;
    setDeletable();
    update();
  }

  void setDeletable() {
    deletable = !deletable;
    update();
  }

  onSelected(int index) {
    i = index;
    update();
  }

  void confirmDeletion(
    BuildContext context,
    String teacherId,
  ) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      height: height - 750,
                      width: width * 0.9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'حذف  المجموعة',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 5.0, left: 5.0),
                            child: Divider(
                              color: primaryColor,
                              thickness: 2.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          CustomText(
                            text: 'هل تريد حذف هذه المجموعة',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            alignment: Alignment.topRight,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setDeletable();
                                  },
                                  child: Text(
                                    'لا',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: primaryColor),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      if (result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        Navigator.pop(context);
                                        await deleteGroup(
                                          teacherId,
                                        );
                                      }
                                    } on SocketException catch (_) {
                                      Navigator.pop(context);
                                      globalKey.currentState
                                          .showSnackBar(snackBar2);
                                    }
                                  },
                                  child: Text(
                                    'نعم',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: primaryColor),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  void setTeacherId(String id) {
    teacherId = id;
    update();
  }
}
