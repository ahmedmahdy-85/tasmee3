import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/pages/authentication/sign_up_teacher.dart';
import 'package:tasmee3/pages/teacher/manage_students.dart';
import 'package:tasmee3/view_model/manage_students_viewmodel.dart';
import 'package:tasmee3/widgets/custom_button.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class MyGroup extends StatelessWidget {
  final UserModel currentUser;
  MyGroup({this.currentUser});

  handleSearch(String name) {
    Get.find<ManageStudentsViewModel>().getUserSearch(name);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageStudentsViewModel>(
      init: ManageStudentsViewModel(),
      builder: (controller) => controller.loading.value
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ))
          : GetBuilder<ManageStudentsViewModel>(
              init: Get.find(),
              builder: (controller) => Scaffold(
                appBar: AppBar(
                  backgroundColor: primaryColor,
                  centerTitle: true,
                  toolbarHeight: 140.0,
                  title: Column(
                    children: [
                      CustomText(
                        text: controller.groupName,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        controller: controller.searchController,
                        onFieldSubmitted: handleSearch,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'ابحث عن طالب.....',
                          hintTextDirection: TextDirection.rtl,
                          filled: true,
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                size: 30.0,
                                color: primaryColor,
                              ),
                              onPressed: () => controller.getUserSearch(
                                  controller.searchController.text.trim())),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              controller.clearSearch();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: !controller.deletable
                      ? null
                      : [
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                  onPressed: () async => !controller.isSearch
                                      ? await controller.confirmDeletion(
                                          context,
                                          currentUser.teacherId,
                                          controller.studentId,
                                          controller.students.indexWhere(
                                              (element) =>
                                                  element.id ==
                                                  controller.studentId))
                                      : await controller.confirmDeletion(
                                          context,
                                          currentUser.teacherId,
                                          controller.studentId,
                                          controller.searchList.indexWhere(
                                              (element) =>
                                                  element.id ==
                                                  controller.studentId))),
                            ),
                          ),
                        ],
                ),
                floatingActionButton: Container(
                  height: 75,
                  width: 80,
                  child: FloatingActionButton(
                    onPressed: () {
                      Get.to(() => SignUpTeacher(
                            currentUser: currentUser,
                          ));
                    },
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32.0,
                    ),
                  ),
                ),
                body: Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: !controller.isSearch
                              ? ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  separatorBuilder: (context, index) =>
                                      Divider(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Get.to(() => ManageStudents(
                                          teacherId: currentUser.id,
                                          studentId:
                                              controller.students[index].id)),
                                      onLongPress: () {
                                        controller.onSelected(index);
                                        controller.setDeletable();
                                        controller.setStudentId(
                                            controller.students[index].id);
                                      },
                                      child: Container(
                                        //padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: controller.deletable &&
                                                  controller.i == index
                                              ? Colors.grey
                                              : Colors.white,
                                        ),
                                        height: 80.0,
                                        child: Center(
                                          child: ListTile(
                                            leading: CustomButton(
                                              textColor: Colors.white,
                                              buttonColor: controller
                                                      .students[index].isActive
                                                  ? primaryColor
                                                  : accentColor,
                                              width: 100.0,
                                              text: controller
                                                      .students[index].isActive
                                                  ? 'توقيف'
                                                  : 'تفعيل',
                                              height: 42.0,
                                              fontSize: 14.0,
                                              onPressed: () async {
                                                try {
                                                  final result =
                                                      await InternetAddress
                                                          .lookup('google.com');
                                                  if (result.isNotEmpty &&
                                                      result[0]
                                                          .rawAddress
                                                          .isNotEmpty) {
                                                    await controller
                                                        .updateStudentStatus(
                                                            controller
                                                                .students[index]
                                                                .id,
                                                            currentUser.id,
                                                            index);
                                                  }
                                                } on SocketException catch (_) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          controller.snackBar2);
                                                }
                                              },
                                            ),
                                            title: Text(
                                              controller.students[index].name
                                                  .trim(),
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              radius: 35.0,
                                              child: Text(
                                                controller.students[index].name
                                                    .trim()
                                                    .substring(0, 1),
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: controller.students.length)
                              : ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  separatorBuilder: (context, index) =>
                                      Divider(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Get.to(() => ManageStudents(
                                          teacherId: currentUser.id,
                                          studentId:
                                              controller.searchList[index].id)),
                                      onLongPress: () {
                                        controller.onSelected(index);
                                        controller.setDeletable();
                                        controller.setStudentId(
                                            controller.searchList[index].id);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: controller.deletable &&
                                                  controller.i == index
                                              ? Colors.grey
                                              : Colors.white,
                                        ),
                                        height: 80.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomButton(
                                              textColor: Colors.white,
                                              buttonColor: controller
                                                      .searchList[index]
                                                      .isActive
                                                  ? primaryColor
                                                  : accentColor,
                                              width: 100.0,
                                              text: controller.searchList[index]
                                                      .isActive
                                                  ? 'توقيف'
                                                  : 'تفعيل',
                                              height: 42.0,
                                              fontSize: 14.0,
                                              onPressed: () async {
                                                try {
                                                  final result =
                                                      await InternetAddress
                                                          .lookup('google.com');
                                                  if (result.isNotEmpty &&
                                                      result[0]
                                                          .rawAddress
                                                          .isNotEmpty) {
                                                    await controller
                                                        .updateStatusInSearchList(
                                                            controller
                                                                .searchList[
                                                                    index]
                                                                .id,
                                                            currentUser.id,
                                                            index);
                                                  }
                                                } on SocketException catch (_) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          controller.snackBar2);
                                                }
                                              },
                                            ),
                                            Text(
                                              controller.searchList[index].name,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              radius: 35.0,
                                              child: Text(
                                                controller
                                                    .searchList[index].name
                                                    .trim()
                                                    .substring(0, 1),
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: controller.searchList.length)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
