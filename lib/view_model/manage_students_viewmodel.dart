import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/student_model.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/services/firestore_user.dart';
import 'package:tasmee3/widgets/custom_text.dart';
import 'package:uuid/uuid.dart';

class ManageStudentsViewModel extends GetxController {
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  bool clickable = true;
  List<StudentModel> searchList = [];
  String studentId;
  String teacherId;
  List<StudentModel> students;
  int i;
  LocalStorageData localStorageData = Get.find();
  String groupName;
  String stat;
  bool deletable = false;
  String id = Uuid().v4();
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  String registerUserName, registerName, registerPassword, phoneNum;
  List<String> signUpErrors = [];
  bool online = false;
  bool registerVal = true;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final snackBar = SnackBar(
    content: Text(
      'تم  الارسال',
      textDirection: TextDirection.rtl,
      style: TextStyle(fontSize: 17.0),
    ),
    duration: Duration(seconds: 2),
  );
  final snackBar2 = SnackBar(
    content: Text(
      'لا يوجد اتصال بالانترنت',
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  final snackBar3 = SnackBar(
    content: Text(
      'لا يوجد عذر',
      textDirection: TextDirection.rtl,
      style: TextStyle(fontSize: 18.0),
    ),
    duration: Duration(seconds: 2),
  );
  final snackBar4 = SnackBar(
    content: Text(
      'لا توجد بيانات لهذا اليوم',
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );

  void onInit() async {
    super.onInit();
    await getGroupName();
    await getMyGroupStudents();
  }

  void setClickable() {
    clickable = !clickable;
    update();
  }

  void setActivationForStudentsList(index) {
    students[index].isActive = !students[index].isActive;
    update();
  }

  void setActivationForSearchList(index) {
    searchList[index].isActive = !searchList[index].isActive;
    update();
  }

  void getUserSearch(String name) {
    _loading.value = true;
    searchList.clear();
    for (StudentModel student in students) {
      if (student.name.contains(name)) {
        searchList.add(student);
      }
    }
    if (searchList.isNotEmpty) {
      isSearch = true;
      searchList.sort();
    }
    _loading.value = false;
    update();
  }

  void clearSearch() {
    searchController.clear();
    isSearch = false;
    searchList.clear();
    update();
  }

  void setLoading() {
    _loading.value = !_loading.value;
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

  void signUp(
    String uid,
    BuildContext context,
  ) async {
    setLoading();
    setClickable();
    UserModel user = UserModel(
        name: registerName.trim(),
        username: registerUserName,
        password: registerPassword,
        id: id,
        teacherId: uid,
        isTeacher: false,
        isAdmin: false);
    await FireStoreUser()
        .getSpecificUser(
      registerUserName.replaceAll(new RegExp(r"\s+"), ""),
      registerPassword,
    )
        .then((value) async {
      if (value.isNotEmpty) {
        setClickable();
        setLoading();
        final snackBar = SnackBar(
          content: Text(
            'هذا الحساب تم تسجيله من قبل',
            textDirection: TextDirection.rtl,
          ),
          duration: Duration(seconds: 2),
        );
        globalKey.currentState.showSnackBar(snackBar);
        return;
      } else {
        await FireStoreUser().addUserToFirestore(user);
        StudentModel student = StudentModel(
            name: registerName,
            status: 'لم يسمع بعد',
            activationDay: 0,
            isActive: true,
            endOfGoal: '',
            startOfGoal: '',
            uncompleteTasmee3Details: '',
            uncompleteTasmee3Date: '',
            username: registerUserName,
            id: user.id,
            goal: '',
            groupName: groupName,
            teacherId: uid,
            phone: registerUserName);
        await FireStoreUser().addStudentToFirestore(uid, student);
        students.add(student);
        id = Uuid().v4();
        clickable = true;
        _loading.value = false;
        update();
        Get.back();
      }
    });
  }

  Future<void> getGroupName() async {
    _loading.value = true;
    await localStorageData.getUser.then((value) {
      if (value != null) {
        teacherId = value.id;
      }
    });
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(teacherId)
        .get()
        .then((value) => groupName = value.get('groupName'));
    _loading.value = false;
    update();
  }

  Future<void> getMyGroupStudents() async {
    _loading.value = true;
    final List<DocumentSnapshot> documents = (await _studentsCollection
            .doc(teacherId)
            .collection('StudentsList')
            .get())
        .docs;
    students = documents
        .map((documentSnapshot) =>
            StudentModel.fromJson(documentSnapshot.data()))
        .toList();
    students.sort();
    _loading.value = false;
    update();
  }

  Future<void> updateStudentStatus(
      String id, String teacherId, int index) async {
    setActivationForStudentsList(index);
    try {
      await _studentsCollection
          .doc(teacherId)
          .collection('StudentsList')
          .doc(id)
          .get()
          .then((value) async {
        if (value.get('isActive') == true) {
          await _studentsCollection
              .doc(teacherId)
              .collection('StudentsList')
              .doc(id)
              .update({'isActive': false});
        } else {
          await _studentsCollection
              .doc(teacherId)
              .collection('StudentsList')
              .doc(id)
              .update({'isActive': true});
        }
      });
    } catch (e) {
      setActivationForStudentsList(index);
    }

    _loading.value = false;
    update();
  }

  Future<void> updateStatusInSearchList(
      String id, String teacherId, int index) async {
    setActivationForSearchList(index);
    try {
      await _studentsCollection
          .doc(teacherId)
          .collection('StudentsList')
          .doc(id)
          .get()
          .then((value) async {
        if (value.get('isActive') == true) {
          await _studentsCollection
              .doc(teacherId)
              .collection('StudentsList')
              .doc(id)
              .update({'isActive': false});
        } else {
          await _studentsCollection
              .doc(teacherId)
              .collection('StudentsList')
              .doc(id)
              .update({'isActive': true});
        }
      });
    } catch (e) {
      setActivationForSearchList(index);
    }
    _loading.value = false;
    update();
  }

  Future<void> deleteUser(String teacherId, String studentId, int index) async {
    setLoading();
    await _usersCollection.doc(studentId).delete();
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .doc(studentId)
        .collection('ProgressList')
        .get()
        .then((value) async {
      if (value.docs.length > 0) {
        value.docs.clear();
      }
      await _studentsCollection
          .doc(teacherId)
          .collection('StudentsList')
          .doc(studentId)
          .delete();
    }).then((value) {
      i = 100000;
      setDeletable();
      students.removeAt(index);
      _loading.value = false;
      update();
    }).catchError((error) {
      _loading.value = false;
      update();
      Get.snackbar('تعذر تحديث البيانات', 'يوجد مشكلة في الاتصال بالانترنت',
          colorText: Colors.black, snackPosition: SnackPosition.BOTTOM);
    });
  }

  Future<void> deleteUserFromSearch(
      String teacherId, String studentId, int index) async {
    setLoading();
    await _usersCollection.doc(studentId).delete();
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .doc(studentId)
        .collection('ProgressList')
        .get()
        .then((value) async {
      if (value.docs.length > 0) {
        value.docs.clear();
      }
      await _studentsCollection
          .doc(teacherId)
          .collection('StudentsList')
          .doc(studentId)
          .delete();
    }).then((value) async {
      i = 100000;
      setDeletable();
      searchList.removeAt(index);
      students.removeWhere((element) => element.id == studentId);
      _loading.value = false;
      update();
    }).catchError((error) {
      _loading.value = false;
      update();
      Get.snackbar('تعذر تحديث البيانات', 'يوجد مشكلة في الاتصال بالانترنت',
          colorText: Colors.black, snackPosition: SnackPosition.BOTTOM);
    });
  }

  void setDeletable() {
    deletable = !deletable;
    update();
  }

  onSelected(int index) {
    i = index;
    update();
  }

  Future<void> confirmDeletion(BuildContext context, String teacherId,
      String studentId, int index) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  Orientation orientation = MediaQuery.of(context).orientation;

                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      height: orientation == Orientation.portrait
                          ? height * 0.2
                          : height * 0.5,
                      width: orientation == Orientation.portrait
                          ? width * 0.9
                          : width * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'حذف  الطالب',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 5.0, left: 5.0, top: 10.0),
                            child: Divider(
                              color: primaryColor,
                              thickness: 2.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          CustomText(
                            text: 'هل تريد حذف هذا الطالب',
                            fontSize: 17.0,
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
                                        !isSearch
                                            ? await deleteUser(
                                                teacherId, studentId, index)
                                            : await deleteUserFromSearch(
                                                teacherId, studentId, index);
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
                                        fontSize: 20.0,
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

  void setStudentId(String id) {
    studentId = id;
    update();
  }
}
