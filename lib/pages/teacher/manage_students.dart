import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tasmee3/view_model/manage_students_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/widgets/custom_button.dart';
import 'package:tasmee3/widgets/custom_text.dart';
import 'package:tasmee3/widgets/no_account_bottom_sheet.dart';
import 'package:tasmee3/widgets/show_bottom_sheet.dart';

class ManageStudents extends StatefulWidget {
  final String studentId;
  final String teacherId;
  ManageStudents({this.teacherId, this.studentId});

  @override
  _ManageStudentsState createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  List<String> statusList = [
    'تم كامل',
    'تم ناقص',
    'تم كامل مع العقوبة',
    'عدم تسميع'
  ];
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  String status;
  DateTime selectedDate;
  bool sameDay = false;
  TextEditingController dateController = TextEditingController();

  Future<void> getStatus(DateTime date) async {
    await Jiffy.locale("ar");

    await _studentsCollection
        .doc(widget.teacherId)
        .collection('StudentsList')
        .doc(widget.studentId)
        .collection("ProgressList")
        .where('year', isEqualTo: date.year)
        .where('month', isEqualTo: date.month)
        .where('day', isEqualTo: date.day)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        setState(() {
          status = 'عدم تسميع';
          dateController.text = Jiffy(date).format("do MMMM yyyy");
          selectedDate = date;
        });
      } else {
        setState(() {
          status = value.docs.first.data()['status'];
          dateController.text = Jiffy(date).format("do MMMM yyyy");
          selectedDate = date;
        });
      }
    });
  }

  Future<void> updateStatus(String newStatus, DateTime date) async {
    if (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day) {
      await _studentsCollection
          .doc(widget.teacherId)
          .collection('StudentsList')
          .doc(widget.studentId)
          .update({'activationDay': DateTime.now().day, 'status': newStatus});
    }
    await _studentsCollection
        .doc(widget.teacherId)
        .collection('StudentsList')
        .doc(widget.studentId)
        .collection("ProgressList")
        .where('year', isEqualTo: date.year)
        .where('month', isEqualTo: date.month)
        .where('day', isEqualTo: date.day)
        .limit(1)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        showBottom(
            context,
            NoAccount(
              text: 'لا يوجد بيانات لهذا اليوم',
            ));
      } else {
        value.docs.forEach((element) {
          if (newStatus == 'تم كامل') {
            element.reference.update({
              'status': newStatus,
              'complete': 1,
              'completeWithPunish': 0,
              'noTasmee3': 0,
              'uncomplete': 0,
            });
          } else if (newStatus == 'تم كامل مع العقوبة') {
            element.reference.update({
              'status': newStatus,
              'complete': 0,
              'completeWithPunish': 1,
              'noTasmee3': 0,
              'uncomplete': 0
            });
          } else if (newStatus == 'عدم تسميع') {
            element.reference.update({
              'status': newStatus,
              'complete': 0,
              'completeWithPunish': 0,
              'noTasmee3': 1,
              'uncomplete': 0,
            });
          } else if (newStatus == 'تم ناقص') {
            element.reference.update({
              'status': newStatus,
              'complete': 0,
              'completeWithPunish': 0,
              'noTasmee3': 0,
              'uncomplete': 1,
            });
          }
          showBottom(
              context,
              NoAccount(
                text: 'تم تعديل البيانات بنجاح',
              ));
        });
      }
    });
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;
    setState(() {
      selectedDate = newDate;
    });

    await Jiffy.locale("ar");
    dateController.text = Jiffy(selectedDate).format("do MMMM yyyy");
    await getStatus(selectedDate);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatus(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageStudentsViewModel>(
      init: Get.find(),
      builder: (controller) => controller.loading.value
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            )
          : GetBuilder<ManageStudentsViewModel>(
              init: Get.find(),
              builder: (controller) => Scaffold(
                key: controller.globalKey,
                backgroundColor: Colors.grey.shade200,
                body: StreamBuilder<DocumentSnapshot>(
                  stream: _studentsCollection
                      .doc(widget.teacherId)
                      .collection('StudentsList')
                      .doc(widget.studentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: 30.0,
                                ),
                                onPressed: () => Get.back(),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, right: 10.0, left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: 'ما لم يسمعه الطالب',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Container(
                                child: !snapshot.hasData
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            primaryColor),
                                      )
                                    : Text(
                                        snapshot.data['uncompleteTasmee3Date'],
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                height: 180.0,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey.shade100,
                                    border: Border.all(color: primaryColor)),
                                child: !snapshot.hasData
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            primaryColor),
                                      )
                                    : CustomText(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        text: snapshot
                                            .data['uncompleteTasmee3Details'],
                                      ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Divider(
                                thickness: 2.0,
                              ),
                              SizedBox(
                                height: 70.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: CustomText(
                                  text:
                                      'يمكنك تغيير حالة الطالب من هنا باختيار اليوم والحالة الجديدة.',
                                  alignment: Alignment.topRight,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.0,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await pickDate(context);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 90,
                                        child: Icon(LineAwesomeIcons.calendar,
                                            color: primaryColor, size: 70.0),
                                      ),
                                      // SizedBox(width: 20.0),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color: accentColor,
                                              width: 3.0,
                                            )),
                                        height: 50.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          textDirection: TextDirection.rtl,
                                          enabled: false,
                                          cursorColor: primaryColor,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              height: 1.0,
                                              fontWeight: FontWeight.bold),
                                          controller: dateController,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Container(
                                  padding: EdgeInsets.only(left: 8.0),
                                  height: 50.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: DropdownButton(
                                    dropdownColor: Colors.teal,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                    underline: SizedBox(),
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 80.0),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 40.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    value: status,
                                    onChanged: (value) async {
                                      setState(() {
                                        status = value;
                                      });
                                    },
                                    items: statusList.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              CustomButton(
                                text: 'ارسال',
                                buttonColor: accentColor,
                                textColor: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 50.0,
                                onPressed: () async {
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      await updateStatus(status, selectedDate);
                                    }
                                  } on SocketException catch (_) {
                                    showBottom(
                                        context,
                                        NoAccount(
                                          text: 'لا يوجد اتصال بالانترنت',
                                        ));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
