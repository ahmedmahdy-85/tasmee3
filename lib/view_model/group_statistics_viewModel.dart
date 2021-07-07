import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/progress_model.dart';

class GroupStatisticsViewModel extends GetxController {
  String groupName;
  bool clickable = true;
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');
  List<ProgressModel> progress = [];
  List<ProgressModel> userDetails = [];
  String teacherId;
  int noTasmee3 = 0, uncomplete = 0, complete = 0, completeWithPunish = 0;
  int totalNoTasmee3 = 0,
      totalUncomplete = 0,
      totalComplete = 0,
      totalCompleteWithPunish = 0;

  LocalStorageData localStorageData = Get.find();
  final snackBar = SnackBar(
    content: Text(
      'لا يوجد اتصال بالانترنت',
      style: TextStyle(fontSize: 18.0),
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateUntil = TextEditingController();
  DateTime currentTime = DateTime.now();
  DateTimeRange dateRange;
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
    await Jiffy.locale("ar");
    await getTableStatistics(teacherId, DateTime.now(), DateTime.now());
    await getChartStatistics(teacherId, DateTime.now(), DateTime.now());
    dateFrom.text = Jiffy(DateTime.now()).format("do MMMM yyyy");
    dateUntil.text = Jiffy(DateTime.now()).format("do MMMM yyyy");
  }

  void setClickable() {
    clickable = !clickable;
    update();
  }

  Future<void> getTableStatistics(
      String teacherId, DateTime start, DateTime end) async {
    _loading.value = true;
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await element.reference
            .collection('ProgressList')
            .orderBy('year')
            .orderBy('month')
            .orderBy('day')
            .startAt([start.year, start.month, start.day])
            .endAt([end.year, end.month, end.day])
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
              userDetails.add(ProgressModel(
                studentName: element.data()['name'],
                completeWithPunish: completeWithPunish,
                noTasmee3: noTasmee3,
                uncomplete: uncomplete,
                complete: complete,
              ));
              userDetails.sort();
              completeWithPunish = 0;
              complete = 0;
              uncomplete = 0;
              noTasmee3 = 0;
            });

        update();
      });
    });
    _loading.value = false;
    update();
  }

  Future<void> getChartStatistics(
      String teacherId, DateTime start, DateTime end) async {
    _loading.value = true;
    totalCompleteWithPunish = 0;
    totalNoTasmee3 = 0;
    totalUncomplete = 0;
    totalComplete = 0;
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await element.reference
            .collection('ProgressList')
            .orderBy('year')
            .orderBy('month')
            .orderBy('day')
            .startAt([start.year, start.month, start.day])
            .endAt([end.year, end.month, end.day])
            .get()
            .then((value) {
              progress = value.docs.map((e) {
                ProgressModel newProgress =
                    ProgressModel.fromJson(Map<String, dynamic>.from(e.data()));
                return newProgress;
              }).toList();
              for (ProgressModel p in progress) {
                totalCompleteWithPunish += p.completeWithPunish;
                totalNoTasmee3 += p.noTasmee3;
                totalComplete += p.complete;
                totalUncomplete += p.uncomplete;
                update();
              }
            });
      });
    });

    _loading.value = false;
    update();
  }

  Map generateData() {
    Map<String, double> dataMap = {
      "تم كامل": totalComplete.toDouble(),
      "تم ناقص": totalUncomplete.toDouble(),
      "تم كامل مع العقوبة": totalCompleteWithPunish.toDouble(),
      "عدم تسميع": totalNoTasmee3.toDouble(),
    };
    return dataMap;
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

  Future pickDateRange(
    BuildContext context,
    String teacherId,
  ) async {
    userDetails.clear();
    totalCompleteWithPunish = 0;
    totalNoTasmee3 = 0;
    totalUncomplete = 0;
    totalComplete = 0;
    dateFrom.text = '';
    dateUntil.text = '';
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
    await getTableStatistics(teacherId, dateRange.start, dateRange.end);
    await getChartStatistics(teacherId, dateRange.start, dateRange.end);
    generateData();
    update();
  }

  Widget buildBody(List<ProgressModel> p) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columnSpacing: 9.0,
          dataRowHeight: 30.0,
          dividerThickness: 2.0,
          showBottomBorder: true,
          columns: [
            DataColumn(
                label: Text(
              'عدم تسميع',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700]),
            )),
            DataColumn(
                label: Text('تم كامل مع العقوبة',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700]))),
            DataColumn(
                label: Text('تم ناقص',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700]))),
            DataColumn(
                label: Text('تم كامل',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700]))),
            DataColumn(
                label: Padding(
              padding: EdgeInsets.only(left: 60.0),
              child: Text('الاسم',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.brown[700],
                      fontWeight: FontWeight.w900)),
            )),
          ],
          rows: p
              .map((e) => DataRow(cells: [
                    DataCell(Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        e.noTasmee3.toString(),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataCell(Center(
                      child: Text(
                        e.completeWithPunish.toString(),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataCell(Center(
                      child: Text(
                        e.uncomplete.toString(),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataCell(Center(
                      child: Text(
                        e.complete.toString(),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataCell(Container(
                      width: 140.0,
                      child: Text(
                        e.studentName.trim(),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 12.0),
                      ),
                    )),
                  ]))
              .toList()),
    );
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
}

enum LegendShape { Circle, Rectangle }
