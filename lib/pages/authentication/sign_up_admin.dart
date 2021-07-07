import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/admin_view_model.dart';
import 'package:tasmee3/widgets/error_line.dart';

class SignUpAdmin extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final UserModel currentUser;
  SignUpAdmin({this.currentUser});

  Widget buildForm(
      String text, IconData icon, int values, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: GetBuilder<AdminViewModel>(
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
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
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
    return GetBuilder<AdminViewModel>(
      init: Get.find(),
      builder: (controller) => Scaffold(
        key: controller.globalKey,
        body: controller.loading.value
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
              )
            : GetBuilder<AdminViewModel>(
                init: Get.find(),
                builder: (controller) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.grey[700],
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: 10.0),
                                    height: 60.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      controller:
                                          controller.groupNameController,
                                      cursorColor: primaryColor,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textDirection: TextDirection.rtl,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintTextDirection: TextDirection.rtl,
                                          hintText: 'من فضلك اكتب اسم المجموعة',
                                          hintStyle: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.grey)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Text(
                                      'تسجيل حساب المعلم',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  buildForm('الاسم', Icons.person, 1, context),
                                  buildForm('اسم المستخدم - رقم التليفون',
                                      Icons.phone, 2, context),
                                  buildForm(
                                      'كلمة المرور', Icons.lock, 0, context),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30.0),
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
                                      height: 55.0,
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_formKey.currentState
                                                  .validate() &&
                                              controller.signUpErrors.isEmpty) {
                                            _formKey.currentState.save();
                                            try {
                                              final result =
                                                  await InternetAddress.lookup(
                                                      'google.com');
                                              if (result.isNotEmpty &&
                                                  result[0]
                                                      .rawAddress
                                                      .isNotEmpty) {
                                                await controller
                                                    .signUp(context);
                                              }
                                            } on SocketException catch (_) {
                                              controller.globalKey.currentState
                                                  .showSnackBar(
                                                      controller.snackBar2);
                                            }
                                          }
                                        },
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
                                                fontSize: 16.0),
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
      ),
    );
  }
}
