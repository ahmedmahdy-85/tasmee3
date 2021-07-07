import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_color/random_color.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/pages/authentication/sign_up_admin.dart';
import 'package:tasmee3/view_model/admin_view_model.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class AdminHomeScreen extends StatelessWidget {
  final UserModel currentUser;
  AdminHomeScreen({this.currentUser});

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor = RandomColor();
    return GetBuilder<AdminViewModel>(
        init: AdminViewModel(),
        builder: (controller) => controller.loading.value
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  toolbarHeight: 75,
                  backgroundColor: primaryColor,
                  centerTitle: true,
                  title: CustomText(
                    text: 'الحلقات',
                    color: Colors.white,
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                  ),
                  actions: !controller.deletable
                      ? null
                      : [
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              onPressed: () => controller.confirmDeletion(
                                    context,
                                    controller.teacherId,
                                  )),
                        ],
                ),
                floatingActionButton: Container(
                  height: 75,
                  width: 80,
                  child: FloatingActionButton(
                    onPressed: () {
                      Get.to(() => SignUpAdmin(
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
                body: controller.users.isEmpty
                    ? Container(
                        child: Center(
                          child: CustomText(
                            text: 'اضف مجموعاتك ',
                            fontSize: 40.0,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: controller.users.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onLongPress: () {
                              controller.onSelected(index);
                              controller.setDeletable();
                              controller
                                  .setTeacherId(controller.users[index].id);
                            },
                            onTap: () async {
                              await controller.teacherDelegation(
                                  controller.users[index].id);
                            },
                            child: CircleAvatar(
                              backgroundColor: controller.deletable &&
                                      controller.i == index
                                  ? Colors.grey
                                  : _randomColor.randomColor(
                                      colorBrightness: ColorBrightness.dark),
                              child: CustomText(
                                text: controller.users[index].groupName,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: controller.deletable &&
                                        controller.i == index
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
              ));
  }
}
