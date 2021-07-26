import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/progress_model.dart';
import 'package:tasmee3/pages/version.dart';
import 'package:tasmee3/services/firestore_user.dart';
import 'package:uuid/uuid.dart';

class StudentViewModel extends GetxController {
  String teacherToken;
  final snackBar2 = SnackBar(
    content: Text(
      'لا يوجد اتصال بالانترنت',
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  final snackBar3 = SnackBar(
    content: Text(
      'من فضلك اكتب اولا ما لم تسمعه اليوم',
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  final snackBar4 = SnackBar(
    content: Text(
      'من فضلك انتظر حتي تظهر مهمتك:)',
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  DateTime currentDate = DateTime.now();
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');
  String userId;
  String teacherId;
  String name;
  String groupName;
  bool canSendData = true;
  String id = Uuid().v4();

  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  LocalStorageData localStorageData = Get.find();
  TextEditingController dateUntil = TextEditingController();
  TextEditingController dateFrom = TextEditingController();
  TextEditingController uncompleteDetailsController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  String uncompleteTasmee3Date = Jiffy(DateTime.now()).format("do MMMM yyyy");

  void onInit() async {
    super.onInit();
    await getVersion();
    await getCurrentUserData();
    await getGroupName();
    await checkActivation();
    await getDataFromFireStore();
    await getTeacherToken();
  }

  void setLoading() {
    _loading.value = true;
    update();
  }

  Future<void> getTeacherToken() async {
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(teacherId)
        .get()
        .then((value) {
      teacherToken = value.data()['token'];
    });
  }

  Future<void> checkActivation() async {
    _loading.value = true;
    await getCurrentUserData();
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .doc(userId)
        .get()
        .then((value) async {
      if (value != null) {
        if (value.data()['isActive'] != true ||
            value.data()['activationDay'] == currentDate.day) {
          canSendData = false;
        } else {
          canSendData = true;
          await value.reference.update({'status': 'لم يسمع بعد'});
        }
      }
    });
    _loading.value = false;
    update();
  }

  Future<void> deactivateAfterAction() async {
    _loading.value = true;
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .doc(userId)
        .update({'activationDay': currentDate.day});
    canSendData = false;
    _loading.value = false;
    update();
  }

  Future<void> addUncompleteTasmee3() async {
    setLoading();
    if (uncompleteDetailsController.text.isNotEmpty) {
      await Jiffy.locale("ar");
      ProgressModel p = ProgressModel(
        uncompleteTasmee3Details: uncompleteDetailsController.text,
        completeWithPunish: 0,
        noTasmee3: 0,
        uncomplete: 1,
        day: currentDate.day,
        month: currentDate.month,
        year: currentDate.year,
        studentName: name,
        complete: 0,
        status: 'تم ناقص',
        date: Jiffy(DateTime.now()).format("do MMMM yyyy").toString(),
      );
      await FireStoreUser()
          .addProgressToFirestore(
              p,
              teacherId,
              userId,
              '${DateTime.now().day}' +
                  '${DateTime.now().month}' +
                  '${DateTime.now().year}')
          .then((value) async {
        await Jiffy.locale("ar");
        await _studentsCollection
            .doc(teacherId)
            .collection('StudentsList')
            .doc(userId)
            .update({
          'uncompleteTasmee3Details': uncompleteDetailsController.text,
          'status': 'تم ناقص',
          'uncompleteTasmee3Date': Jiffy(DateTime.now()).format("do MMMM yyyy"),
        }).then((value) async {
          uncompleteDetailsController.clear();
          canSendData = false;
          await deactivateAfterAction();
          _loading.value = false;
          update();
          Get.snackbar('تم الارسال', 'تم تحديث البيانات بنجاح',
              colorText: Colors.black, snackPosition: SnackPosition.BOTTOM);
        });
      });
    } else {
      _loading.value = false;
      update();
      globalKey.currentState.showSnackBar(snackBar3);
    }
  }

  Future<void> addCompleteWithPunish() async {
    setLoading();
    if (goalController.text.isNotEmpty) {
      await Jiffy.locale("ar");
      ProgressModel p = ProgressModel(
        complete: 0,
        completeWithPunish: 1,
        noTasmee3: 0,
        uncomplete: 0,
        studentName: name,
        day: currentDate.day,
        month: currentDate.month,
        year: currentDate.year,
        uncompleteTasmee3Details: '',
        status: 'تم كامل مع العقوبة',
        date: Jiffy(currentDate).format("do MMMM yyyy").toString(),
      );
      await FireStoreUser()
          .addProgressToFirestore(
              p,
              teacherId,
              userId,
              '${DateTime.now().day}' +
                  '${DateTime.now().month}' +
                  '${DateTime.now().year}')
          .then((value) async {
        await Jiffy.locale("ar");
        await _studentsCollection
            .doc(teacherId)
            .collection('StudentsList')
            .doc(userId)
            .update({
          'status': 'تم كامل مع العقوبة',
        }).then((value) async {
          canSendData = false;
          await deactivateAfterAction();
          _loading.value = false;
          update();
          Get.snackbar('تم الارسال', 'تم تحديث البيانات بنجاح',
              colorText: Colors.black, snackPosition: SnackPosition.BOTTOM);
        });
      });
    } else {
      _loading.value = false;
      update();
      globalKey.currentState.showSnackBar(snackBar4);
    }
  }

  Future<void> addTasmee3Koli() async {
    setLoading();
    if (goalController.text.isNotEmpty) {
      await Jiffy.locale("ar");
      ProgressModel p = ProgressModel(
        noTasmee3: 0,
        completeWithPunish: 0,
        complete: 1,
        studentName: name,
        uncompleteTasmee3Details: '',
        uncomplete: 0,
        status: 'تم كامل',
        day: currentDate.day,
        month: currentDate.month,
        year: currentDate.year,
        date: Jiffy(currentDate).format("do MMMM yyyy").toString(),
      );
      await FireStoreUser()
          .addProgressToFirestore(
              p,
              teacherId,
              userId,
              '${DateTime.now().day}' +
                  '${DateTime.now().month}' +
                  '${DateTime.now().year}')
          .then((value) async {
        await Jiffy.locale("ar");
        await _studentsCollection
            .doc(teacherId)
            .collection('StudentsList')
            .doc(userId)
            .update({
          'status': 'تم كامل',
        }).then((value) async {
          canSendData = false;
          await deactivateAfterAction();
          _loading.value = false;
          update();
          Get.snackbar('تم الارسال', 'تم تحديث البيانات بنجاح',
              colorText: Colors.black, snackPosition: SnackPosition.BOTTOM);
        });
      });
    } else {
      _loading.value = false;
      update();
      globalKey.currentState.showSnackBar(snackBar4);
    }
  }

  Future<void> getCurrentUserData() async {
    _loading.value = true;
    await localStorageData.getUser.then((value) {
      if (value != null) {
        userId = value.id;
        name = value.name;
        teacherId = value.teacherId;
      }
    });
    _loading.value = false;
    update();
  }

  getDataFromFireStore() async {
    _loading.value = true;
    await getCurrentUserData();
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(teacherId)
        .get()
        .then((value) async {
      if (value.exists) {
        await Jiffy.locale("ar");
        dateFrom.text = value.data()['startOfGoal'];
        dateUntil.text = value.data()['endOfGoal'];
        goalController.text = value.data()['goal'];
        await _studentsCollection
            .doc(teacherId)
            .collection('StudentsList')
            .doc(userId)
            .update({
          'goal': value.data()['goal'],
          'startOfGoal': value.data()['startOfGoal'],
          'endOfGoal': value.data()['endOfGoal']
        });
      }

      _loading.value = false;
      update();
    });
  }

  Future<bool> addNotifications(String userToken) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': 1,
        'status': 'done'
      },
      'to': userToken,
      'priority': 'high',
      "notification": {
        "title": 'حصون',
        "body": '$name تود ان تبلغك بما لم تسمعه اليوم ',
      },
      "collapse_key": "type_a",
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAFqK4Wks:APA91bFfo6swpnRrgpM-T3NL-DqK6Uuq4z3w3Z5vsCqm4afe4bNLXJ0H8GRqVVHCOhGgD1d9ii811gv1kJKReuHlle4KkUP_Ovyt6VW58Lib8md_G4JBGSAYCw_Y4yS3nd2hRRKo5Tbq'
    };

    final response = await Dio().post(
      postUrl,
      data: data,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  Future<void> getGroupName() async {
    _loading.value = true;
    await _teachersCollection
        .doc('admin@123456')
        .collection('TeachersList')
        .doc(teacherId)
        .get()
        .then((value) => groupName = value.get('groupName'));
    _loading.value = false;
    update();
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
}
