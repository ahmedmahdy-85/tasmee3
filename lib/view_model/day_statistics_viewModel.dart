import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasmee3/model/progress_model.dart';

class TeacherDayStatisticsViewModel extends GetxController {
  String groupName;
  bool clickable = true;
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');
  List<ProgressModel> progress = [];
  String teacherId;
  int noTasmee3 = 0, uncomplete = 0, complete = 0, completeWithPunish = 0;

  LocalStorageData localStorageData = Get.find();
  final snackBar = SnackBar(
    content: Text(
      'لا يوجد اتصال بالانترنت',
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  DateTime currentDate = DateTime.now();
  DateTime selectedDate;
  TextEditingController dateController = TextEditingController();
  List<Color> colorList = [
    Colors.green,
    Colors.brown,
    Colors.blue,
    Colors.red,
  ];
  ChartType chartType = ChartType.disc;
  double ringStrokeWidth = 32;
  double chartLegendSpacing = 32;

  bool showLegendsInRow = false;
  bool showLegends = true;

  bool showChartValueBackground = true;
  bool showChartValues = true;
  bool showChartValuesInPercentage = false;
  bool showChartValuesOutside = false;

  LegendShape legendShape = LegendShape.Circle;
  LegendPosition legendPosition = LegendPosition.right;

  int key = 0;

  void onInit() async {
    super.onInit();
    await getCurrentUserData();
    await getGroupName();
    await getCurrentDate();
    await getStatisticsPerDay(
        currentDate.day, currentDate.month, currentDate.year, teacherId);
  }

  void setClickable() {
    clickable = !clickable;
    update();
  }

  getCurrentDate() async {
    await Jiffy.locale("ar");
    dateController.text = Jiffy(currentDate).format("do MMMM yyyy");
  }

  Future<void> getCurrentUserData() async {
    _loading.value = true;
    await localStorageData.getUser.then((value) {
      if (value != null) {
        teacherId = value.id;
      }
    });
    _loading.value = false;
    update();
  }

  Future<void> getStatisticsPerDay(
      int day, int month, int year, String teacherId) async {
    _loading.value = true;
    noTasmee3 = 0;
    uncomplete = 0;
    complete = 0;
    completeWithPunish = 0;
    await getCurrentUserData();
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await element.reference
            .collection('ProgressList')
            .where('year', isEqualTo: year)
            .where('month', isEqualTo: month)
            .where('day', isEqualTo: day)
            .get()
            .then((value) {
          progress = value.docs.map((e) {
            ProgressModel newProgress =
                ProgressModel.fromJson(Map<String, dynamic>.from(e.data()));
            return newProgress;
          }).toList();
          for (ProgressModel p in progress) {
            completeWithPunish += p.completeWithPunish;

            noTasmee3 += p.noTasmee3;
            complete += p.complete;
            uncomplete += p.uncomplete;
            update();
          }
        });
      });
    });

    _loading.value = false;
    update();
  }

  Future pickDate(BuildContext context) async {
    noTasmee3 = 0;
    complete = 0;
    completeWithPunish = 0;
    uncomplete = 0;
    dateController.text = '';
    progress.clear();
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;
    selectedDate = newDate;

    await getCurrentUserData();
    await getStatisticsPerDay(
        selectedDate.day, selectedDate.month, selectedDate.year, teacherId);
    generateData();
    await Jiffy.locale("ar");
    dateController.text = Jiffy(selectedDate).format("do MMMM yyyy");
    update();
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

  Map generateData() {
    Map<String, double> dataMap = {
      "تم كامل": complete.toDouble(),
      "تم ناقص": uncomplete.toDouble(),
      "تم كامل مع العقوبة": completeWithPunish.toDouble(),
      "عدم تسميع": noTasmee3.toDouble(),
    };
    return dataMap;
  }
}

enum LegendShape { Circle, Rectangle }
