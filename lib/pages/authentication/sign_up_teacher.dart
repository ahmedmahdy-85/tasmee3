import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/manage_students_viewmodel.dart';
import 'package:tasmee3/widgets/error_line.dart';

class SignUpTeacher extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final UserModel currentUser;
  SignUpTeacher({this.currentUser});

  Widget buildForm(
      String text, IconData icon, int values, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: GetBuilder<ManageStudentsViewModel>(
        init: Get.find(),
        builder: (controller) => Container(
          alignment: Alignment.center,
          height: 70.0,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: primaryColor,
                width: 2.0,
              )),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              keyboardType: values == 1
                  ? TextInputType.emailAddress
                  : values == 2
                      ? TextInputType.phone
                      : TextInputType.visiblePassword,
              onSaved: (value) {
                controller.registerOnSaved(values, value);
              },
              onChanged: (value) {
                controller.registerOnChanged(value, values);
              },
              validator: (value) {
                controller.registerValidator(value, values);
                return null;
              },
              obscureText: (values == 0 && controller.registerVal == true)
                  ? true
                  : false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  size: 30.0,
                  color: accentColor,
                ),
                hintText: text,
                hintStyle: TextStyle(fontSize: 13.0),
                suffixIcon: values == 0
                    ? IconButton(
                        icon: (controller.registerVal == true)
                            ? Icon(
                                LineAwesomeIcons.eye,
                                size: 30.0,
                                color: accentColor,
                              )
                            : Icon(
                                LineAwesomeIcons.eye_slash,
                                size: 30.0,
                                color: accentColor,
                              ),
                        onPressed: () {
                          controller.hideRegisterVal();
                        },
                      )
                    : Icon(null),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageStudentsViewModel>(
      init: Get.find(),
      builder: (controller) => Scaffold(
        key: controller.globalKey,
        body: controller.loading.value
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[700],
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                            ),
                            child: Text(
                              'انشاءحساب',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'تسجيل الحساب',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildForm('الاسم', Icons.person, 1, context),
                                buildForm('اسم المستخدم - رقم التليفون',
                                    Icons.phone, 2, context),
                                buildForm(
                                    'كلمة المرور', Icons.lock, 0, context),
                                Padding(
                                  padding: const EdgeInsets.only(right: 50.0),
                                  child: ErrorLine(
                                    errors: controller.signUpErrors,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: SizedBox(
                                    height: 60.0,
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    child: MaterialButton(
                                      onPressed: controller.clickable
                                          ? () async {
                                              if (_formKey.currentState
                                                      .validate() &&
                                                  controller
                                                      .signUpErrors.isEmpty) {
                                                _formKey.currentState.save();
                                                try {
                                                  final result =
                                                      await InternetAddress
                                                          .lookup('google.com');
                                                  if (result.isNotEmpty &&
                                                      result[0]
                                                          .rawAddress
                                                          .isNotEmpty) {
                                                    controller.signUp(
                                                      currentUser.id,
                                                      context,
                                                    );
                                                  }
                                                } on SocketException catch (_) {
                                                  controller
                                                      .globalKey.currentState
                                                      .showSnackBar(
                                                          controller.snackBar2);
                                                }
                                              }
                                            }
                                          : null,
                                      color: primaryColor,
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'تسجيل الحساب',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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
