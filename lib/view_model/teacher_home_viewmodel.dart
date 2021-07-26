import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/admin_model.dart';
import 'package:tasmee3/model/progress_model.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/pages/control_view.dart';
import 'package:tasmee3/pages/version.dart';
import 'package:tasmee3/services/firestore_user.dart';
import 'package:tasmee3/view_model/control_view_model.dart';
import 'package:uuid/uuid.dart';

class TeacherViewModel extends GetxController {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool comeFromAdmin = false;
  String id = Uuid().v4();
  String groupName;
  String name;
  String userId;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  LocalStorageData localStorageData = Get.find();
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  DateTime currentTime = DateTime.now();
  DateTimeRange dateRange;
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateUntil = TextEditingController();
  TextEditingController goalController = TextEditingController();
  final snackBar = SnackBar(
    content: Text(
      'لا يوجد اتصال بالانترنت',
      style: TextStyle(fontSize: 16.0),
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );

  void onInit() async {
    super.onInit();
    await getVersion();
    await getCurrentUserData();
    await getGroupName();
    await getDateRangeFromFireStore();
    await checkTaskDone();
    await setTokenToFirestore();
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;
    dateRange = newDateRange;
    dateFrom.text = await getFrom();
    dateUntil.text = await getUntil();
    update();
  }

  Future<String> getFrom() async {
    if (dateRange == null) {
      return '';
    } else {
      await Jiffy.locale("ar");
      return Jiffy(dateRange.start).format("do MMMM yyyy");
    }
  }

  Future<String> getUntil() async {
    if (dateRange == null) {
      return '';
    } else {
      await Jiffy.locale("ar");
      return Jiffy(dateRange.end).format("do MMMM yyyy");
    }
  }

  Future<void> getCurrentUserData() async {
    _loading.value = true;
    await localStorageData.getUser.then((value) {
      if (value != null) {
        userId = value.id;
        name = value.name;
        if (value.comeFromAdmin == 'true') {
          comeFromAdmin = true;
        }
      }
    });
    _loading.value = false;
    update();
  }

  Future<void> getGroupName() async {
    _loading.value = true;
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(userId)
        .get()
        .then((value) {
      if (value != null) {
        groupName = value.get('groupName');
      }
    });
    _loading.value = false;
    update();
  }

  getDateRangeFromFireStore() async {
    _loading.value = true;
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(userId)
        .get()
        .then((value) async {
      if (value.exists) {
        dateFrom.text = value.get('startOfGoal');
        dateUntil.text = value.get('endOfGoal');
        goalController.text = value.get('goal');
      }

      _loading.value = false;
      update();
    });
  }

  sendDataToFirestore() async {
    _loading.value = true;
    if (dateFrom.text.isNotEmpty &&
        goalController.text.isNotEmpty &&
        dateUntil.text.isNotEmpty) {
      _loading.value = true;
      await _teachersCollection
          .doc('admin@123456')
          .collection('TeachersList')
          .doc(userId)
          .update({
        'startOfGoal': dateFrom.text,
        'endOfGoal': dateUntil.text,
        'goal': goalController.text
      });

      QuerySnapshot eventsQuery = await _studentsCollection
          .doc(userId)
          .collection('StudentsList')
          .get();
      if (eventsQuery.docs.isNotEmpty) {
        eventsQuery.docs.forEach((doc) {
          doc.reference.update({
            'goal': goalController.text,
            'startOfGoal': dateFrom.text,
            'endOfGoal': dateUntil.text
          });
        });
      }

      final snackBar = SnackBar(
        content: Text(
          'لقد تم تسجيل المهمة بنجاح',
          style: TextStyle(fontSize: 18.0),
          textDirection: TextDirection.rtl,
        ),
        duration: Duration(seconds: 2),
      );
      globalKey.currentState.showSnackBar(snackBar);
    } else {
      final snackBar2 = SnackBar(
        content: Text(
          'من فضلك قم بتحديد المهمة اولا',
          style: TextStyle(fontSize: 18.0),
          textDirection: TextDirection.rtl,
        ),
        duration: Duration(seconds: 2),
      );
      globalKey.currentState.showSnackBar(snackBar2);
    }

    _loading.value = false;
    update();
  }

  Future<void> checkDayAction(DateTime day) async {
    _loading.value = true;
    await _studentsCollection
        .doc(userId)
        .collection('StudentsList')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty && value.docs.length > 0) {
        await Jiffy.locale("ar");
        String date = Jiffy(day).format("do MMMM yyyy");
        value.docs.forEach((element) async {
          if (element.data().isNotEmpty) {
            await element.reference
                .collection('ProgressList')
                .where('date', isEqualTo: date)
                .get()
                .then((value) async {
              if (value.docs.isEmpty && value.docs.length == 0) {
                await FireStoreUser().addProgressToFirestore(
                    ProgressModel(
                      completeWithPunish: 0,
                      noTasmee3: 1,
                      uncomplete: 0,
                      studentName: element.get('name'),
                      uncompleteTasmee3Details: '',
                      complete: 0,
                      status: 'عدم تسميع',
                      day: day.day,
                      month: day.month,
                      year: day.year,
                      date: date,
                    ),
                    userId,
                    element.reference.id,
                    '${day.day}' + '${day.month}' + '${day.year}');
              }
            });
          }
        });
      }
    }).then((value) async {
      await deactivateAfterTask().then((value) {
        _loading.value = false;
        update();
      });
    });
  }

  Future<bool> backToAdminScreen() async {
    if (comeFromAdmin) {
      _loading.value = true;
      AdminModel admin;
      await FireStoreUser().getAdminLogin().then((value) {
        admin = (AdminModel.fromJson(value.data()));
      });
      UserModel user = UserModel(
        name: admin.name,
        id: admin.id,
        password: admin.password,
        username: admin.username,
        isTeacher: false,
        isAdmin: true,
      );
      await saveUserToSharedPref(user);
      Get.find<ControlViewModel>().setSavedUser(user);
      _loading.value = false;
      update();
      Get.offAll(() => ControlView());
      return true;
    } else {
      Get.back();
      return true;
    }
  }

  Future<void> saveUserToSharedPref(UserModel userModel) async {
    await localStorageData.setUser(userModel);
    update();
  }

  Future<void> setTokenToFirestore() async {
    String token = await _fcm.getToken();
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(userId)
        .update({'token': token});
  }

  Future<void> getVersion() async {
    _loading.value = true;
    await FirebaseFirestore.instance
        .collection('Version')
        .doc('version@2021')
        .get()
        .then((value) {
      if (value.data().isNotEmpty) {
        if (value.get('version') != 1) {
          Get.offAll(() => VerifyVersion());
        }
      }
    });
    _loading.value = false;
    update();
  }

  Future<void> checkTaskDone() async {
    _loading.value = true;
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(userId)
        .get()
        .then((value) async {
      if (value != null) {
        if (value.get('activeDay') != DateTime.now().day) {
          await checkDayAction(DateTime.now());
        }
      }
    });
    _loading.value = false;
    update();
  }

  Future<void> deactivateAfterTask() async {
    _loading.value = true;
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(userId)
        .update({'activeDay': DateTime.now().day}).then((value) {
      _loading.value = false;
      update();
    });
  }
}
