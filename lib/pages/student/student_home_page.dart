import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/student_home_viewmodel.dart';
import 'package:tasmee3/widgets/custom_button.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class StudentHome extends StatelessWidget {
  final UserModel currentUser;
  StudentHome({this.currentUser});
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('Students');
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentViewModel>(
      init: StudentViewModel(),
      builder: (controller) => controller.loading.value
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            )
          : GetBuilder<StudentViewModel>(
              init: Get.find(),
              builder: (controller) => Scaffold(
                key: controller.globalKey,
                appBar: AppBar(
                  centerTitle: true,
                  title: controller.loading.value
                      ? CustomText(
                          text: '',
                        )
                      : CustomText(
                          text: controller.groupName,
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                  backgroundColor: primaryColor.withOpacity(0.8),
                  toolbarHeight: 75.0,
                ),
                body: Padding(
                  padding: EdgeInsets.only(
                    top: 15.0,
                    right: 15.0,
                    left: 15.0,
                  ),
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(
                                        right: 15.0, left: 15.0),
                                    height: 45.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(
                                          color: accentColor, width: 2.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: _studentsCollection
                                                .doc(controller.teacherId)
                                                .collection('StudentsList')
                                                .doc(controller.userId)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              var doc = snapshot.data;
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              primaryColor)),
                                                );
                                              } else {
                                                return CustomText(
                                                  text: doc['status'],
                                                  color: primaryColor,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w900,
                                                );
                                              }
                                            }),
                                        CustomText(
                                          text: 'الحالة : ',
                                          color: primaryColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w900,
                                        )
                                      ],
                                    )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    controller.loading.value
                                        ? Container()
                                        : FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: CustomText(
                                              text: "اهلا " + controller.name,
                                              fontSize: 16.0,
                                              color: accentColor,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'من فضلك قم بتنفيذ المهمة التالية في الموعد المحدد لك.',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey.shade100,
                                    border: Border.all(
                                      color: accentColor,
                                      width: 2.0,
                                    )),
                                height: 47.0,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: TextField(
                                  textDirection: TextDirection.rtl,
                                  enabled: false,
                                  cursorColor: primaryColor,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      height: 1.0,
                                      fontWeight: FontWeight.bold),
                                  controller: controller.dateUntil,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'الي',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 13.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                ':',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey.shade100,
                                    border: Border.all(
                                      color: accentColor,
                                      width: 2.0,
                                    )),
                                height: 47.0,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: TextField(
                                  textDirection: TextDirection.rtl,
                                  enabled: false,
                                  cursorColor: primaryColor,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      height: 1,
                                      fontWeight: FontWeight.bold),
                                  controller: controller.dateFrom,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'من',
                                    hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 13.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ChatBubble(
                            clipper: ChatBubbleClipper1(
                                type: BubbleType.receiverBubble),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 20),
                            backGroundColor: accentColor.withOpacity(0.6),
                            child: Container(
                              padding: EdgeInsets.only(right: 5.0, left: 5.0),
                              height: 275.0,
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: TextField(
                                controller: controller.goalController,
                                textDirection: TextDirection.rtl,
                                enabled: true,
                                readOnly: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                ),
                                maxLines: 30,
                                decoration: InputDecoration(
                                    // hintTextDirection: TextDirection.rtl,
                                    border: InputBorder.none,
                                    hintText: 'مهمتك سوف تظهر قريبا',
                                    hintTextDirection: TextDirection.rtl,
                                    hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                text: 'تم كامل مع العقوبة',
                                buttonColor: !controller.canSendData
                                    ? Colors.grey
                                    : primaryColor,
                                textColor: !controller.canSendData
                                    ? Colors.black
                                    : Colors.white,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 50.0,
                                onPressed: !controller.canSendData
                                    ? null
                                    : () async {
                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  'google.com');
                                          if (result.isNotEmpty &&
                                              result[0].rawAddress.isNotEmpty) {
                                            controller.addCompleteWithPunish();
                                          }
                                        } on SocketException catch (_) {
                                          controller.globalKey.currentState
                                              .showSnackBar(
                                                  controller.snackBar2);
                                        }
                                      },
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              CustomButton(
                                text: 'تم  كامل',
                                buttonColor: !controller.canSendData
                                    ? Colors.grey
                                    : primaryColor,
                                textColor: !controller.canSendData
                                    ? Colors.black
                                    : Colors.white,
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 50.0,
                                onPressed: !controller.canSendData
                                    ? null
                                    : () async {
                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  'google.com');
                                          if (result.isNotEmpty &&
                                              result[0].rawAddress.isNotEmpty) {
                                            controller.addTasmee3Koli();
                                          }
                                        } on SocketException catch (_) {
                                          controller.globalKey.currentState
                                              .showSnackBar(
                                                  controller.snackBar2);
                                        }
                                      },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                text: 'تم  ناقص',
                                buttonColor: !controller.canSendData
                                    ? Colors.grey
                                    : primaryColor,
                                textColor: !controller.canSendData
                                    ? Colors.black
                                    : Colors.white,
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 50.0,
                                onPressed: !controller.canSendData
                                    ? null
                                    : () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => new AlertDialog(
                                                  elevation: 5.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  content: Builder(
                                                    builder: (context) {
                                                      // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                      var height =
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height;
                                                      var width =
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width;

                                                      return SingleChildScrollView(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.0),
                                                          height: height * 0.4,
                                                          width: width * 0.9,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          20.0),
                                                                  child: Text(
                                                                    'ما لم يتم تسميعه',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 15.0,
                                                                      right:
                                                                          5.0,
                                                                      left:
                                                                          5.0),
                                                                  child:
                                                                      Divider(
                                                                    color:
                                                                        primaryColor,
                                                                    thickness:
                                                                        2.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 20.0,
                                                                ),
                                                                TextField(
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20.0),
                                                                  decoration: InputDecoration(
                                                                      hintText:
                                                                          'اكتب ما لم تسمعه هنا',
                                                                      hintTextDirection:
                                                                          TextDirection
                                                                              .rtl,
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              17.0),
                                                                      focusedBorder:
                                                                          InputBorder
                                                                              .none),
                                                                  cursorColor:
                                                                      primaryColor,
                                                                  controller:
                                                                      controller
                                                                          .uncompleteDetailsController,
                                                                  maxLines: 5,
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl,
                                                                ),
                                                                SizedBox(
                                                                  height: 40.0,
                                                                ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        final result =
                                                                            await InternetAddress.lookup('google.com');
                                                                        if (result.isNotEmpty &&
                                                                            result[0].rawAddress.isNotEmpty) {
                                                                          Navigator.pop(
                                                                              context);
                                                                          await controller
                                                                              .addUncompleteTasmee3();
                                                                          await controller
                                                                              .addNotifications(controller.teacherToken);
                                                                        }
                                                                      } on SocketException catch (_) {
                                                                        Navigator.pop(
                                                                            context);
                                                                        controller
                                                                            .globalKey
                                                                            .currentState
                                                                            .showSnackBar(controller.snackBar2);
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      'ارسال',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              17.0,
                                                                          color:
                                                                              primaryColor),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ));
                                      },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
