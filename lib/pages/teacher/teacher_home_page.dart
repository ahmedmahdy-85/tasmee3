import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/teacher_home_viewmodel.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class TeacherHome extends StatelessWidget {
  final UserModel currentUser;
  TeacherHome({this.currentUser});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherViewModel>(
      init: TeacherViewModel(),
      builder: (controller) => controller.loading.value
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            )
          : GetBuilder<TeacherViewModel>(
              init: Get.find(),
              builder: (controller) => WillPopScope(
                onWillPop: controller.backToAdminScreen,
                child: Scaffold(
                  key: controller.globalKey,
                  appBar: AppBar(
                    centerTitle: true,
                    title: controller.loading.value
                        ? Text('')
                        : CustomText(
                            text: controller.groupName,
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                    leading: controller.comeFromAdmin
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 30.0,
                            ),
                            onPressed: () async =>
                                await controller.backToAdminScreen(),
                          )
                        : null,
                    backgroundColor: primaryColor.withOpacity(0.8),
                    toolbarHeight: 75.0,
                  ),
                  body: Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                      right: 15.0,
                      left: 15.0,
                    ),
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text: controller.name != null
                                        ? "اهلا " + controller.name
                                        : '',
                                    fontSize: 23.0,
                                    color: accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'من فضلك قم بتحديد المهمة التي سوف يقوم طلابك بتنفيذها وحدد تاريخ بدء ونهاية المهمة.',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 15.0),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: GestureDetector(
                                onTap: () async {
                                  await controller.pickDateRange(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 90.0,
                                      child: Icon(LineAwesomeIcons.calendar,
                                          color: primaryColor, size: 70.0),
                                    ),
                                    // SizedBox(width: 20.0),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.grey.shade100,
                                          border: Border.all(
                                            color: accentColor,
                                            width: 3.0,
                                          )),
                                      height: 50.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      child: controller.loading.value
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      primaryColor),
                                            )
                                          : TextField(
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
                                                    color: Colors.grey,
                                                    fontSize: 13.0),
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.grey.shade100,
                                          border: Border.all(
                                            color: accentColor,
                                            width: 3.0,
                                          )),
                                      height: 50.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      child: controller.loading.value
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      primaryColor),
                                            )
                                          : TextField(
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
                                                    color: Colors.grey,
                                                    fontSize: 13.0),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            ChatBubble(
                              clipper: ChatBubbleClipper1(
                                  type: BubbleType.sendBubble),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 20),
                              backGroundColor: accentColor.withOpacity(0.5),
                              child: Container(
                                padding: EdgeInsets.only(
                                  right: 10.0,
                                ),
                                height: 285,
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.70,
                                ),
                                child: TextField(
                                  enabled: true,
                                  textDirection: TextDirection.rtl,
                                  cursorColor: primaryColor,
                                  controller: controller.goalController,
                                  showCursor: true,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                  ),
                                  maxLines: 30,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'من فضلك قم بتحديد المهمة',
                                      hintTextDirection: TextDirection.rtl,
                                      hintStyle: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70.0,
                            ),
                            GetBuilder<TeacherViewModel>(
                              init: Get.find(),
                              builder: (controller) => GestureDetector(
                                onTap: () async {
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      await controller.sendDataToFirestore();
                                    }
                                  } on SocketException catch (_) {
                                    controller.globalKey.currentState
                                        .showSnackBar(controller.snackBar);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Center(
                                    child: Text(
                                      'ارسال',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  height: 50.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
