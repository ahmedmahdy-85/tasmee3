import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/progress_model.dart';
import 'package:tasmee3/widgets/chart_data.dart';

class StudentStatisticsViewModel extends GetxController {
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  final CollectionReference _teachersCollection =
      FirebaseFirestore.instance.collection('Teachers');
  List<ProgressModel> progress = [];
  List<ProgressModel> userDetails = [];
  List<String> studentsNames = [];
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
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateUntil = TextEditingController();
  DateTime currentTime = DateTime.now();
  DateTimeRange dateRange;
  int noTasmee3 = 0;
  int uncomplete = 0;
  int complete = 0;
  int completeWithPunish = 0;
  bool clickable = true;

  String groupName;
  String userId;
  String teacherId;

  List<ChartData> getChartData() {
    final List<ChartData> chartData = [
      ChartData('تم كامل', complete, Colors.green),
      ChartData('تم ناقص', uncomplete, Colors.blue),
      ChartData('تم كامل مع العقوبة', completeWithPunish, Colors.brown),
      ChartData('عدم تسميع', noTasmee3, Colors.red)
    ];
    return chartData;
  }

  void onInit() async {
    super.onInit();
    await getCurrentUserData();
    await getGroupName();
  }

  void setClickable() {
    clickable = !clickable;
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

  Future<void> getCurrentUserData() async {
    _loading.value = true;
    await localStorageData.getUser.then((value) {
      if (value != null) {
        userId = value.id;
        teacherId = value.teacherId;
      }
    });
    _loading.value = false;
    update();
  }

  Future<void> getStudentStatistics(
      String teacherId, String studentId, DateTime start, DateTime end) async {
    _loading.value = true;
    await _studentsCollection
        .doc(teacherId)
        .collection('StudentsList')
        .doc(studentId)
        .collection('ProgressList')
        .orderBy('year')
        .orderBy('month')
        .orderBy('day')
        .startAt([start.year, start.month, start.day])
        .endAt([end.year, end.month, end.day])
        .get()
        .then((value) {
          if (value.docs.isNotEmpty && value.docs.length > 0) {
            progress = value.docs.map((e) {
              ProgressModel newProgress =
                  ProgressModel.fromJson(Map<String, dynamic>.from(e.data()));
              return newProgress;
            }).toList();
            for (ProgressModel p in progress) {
              completeWithPunish += p.completeWithPunish;
              noTasmee3 += p.noTasmee3;
              uncomplete += p.uncomplete;
              complete += p.complete;
              userDetails.add(p);
              update();
            }
          }
        });
    _loading.value = false;
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

  Future pickDateRange(
      BuildContext context, String teacherId, String id) async {
    noTasmee3 = 0;
    uncomplete = 0;
    complete = 0;
    completeWithPunish = 0;
    userDetails.clear();
    dateUntil.text = '';
    dateFrom.text = '';

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

    await getStudentStatistics(teacherId, id, dateRange.start, dateRange.end);
    update();
  }

  Widget buildBody(List<ProgressModel> p, Orientation orientation) {
    return DataTable(
        decoration: ShapeDecoration(shape: Border.all(color: accentColor)),
        columnSpacing: 90.0,
        dataRowHeight: 30.0,
        // dividerThickness: 2.0,
        showBottomBorder: true,
        columns: [
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: 17.0),
            width: orientation == Orientation.portrait ? 100.0 : 140.0,
            child: Center(
              child: Text(
                'الحالة',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )),
          DataColumn(
              label: Container(
            padding: EdgeInsets.only(left: 12.0),
            width: orientation == Orientation.portrait ? 80.0 : 140.0,
            child: Center(
              child: Text('اليوم',
                  style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
            ),
          )),
        ],
        rows: p
            .map((e) => DataRow(cells: [
                  DataCell(Container(
                    width: orientation == Orientation.portrait ? 140.0 : 160.0,
                    child: Center(
                      child: Text(
                        e.status,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                  DataCell(Container(
                    width: orientation == Orientation.portrait ? 80.0 : 120.0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        e.date,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                ]))
            .toList());
  }
}
