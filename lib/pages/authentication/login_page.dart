import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/view_model/auth_view_model.dart';
import 'package:tasmee3/widgets/error_line.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Widget buildForm(
      String text, IconData icon, bool pass, BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: GetBuilder<AuthViewModel>(
        init: Get.find(),
        builder: (controller) => Container(
          height: 70.0,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: primaryColor,
                width: 2.0,
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlignVertical: TextAlignVertical.center,
              keyboardType: pass == false
                  ? TextInputType.phone
                  : TextInputType.visiblePassword,
              onSaved: (value) {
                controller.loginOnSaved(pass, value);
              },
              onChanged: (value) {
                controller.loginOnChanged(value, pass);
              },
              validator: (value) {
                controller.loginValidator(value, pass);
                return null;
              },
              obscureText:
                  (pass == true && controller.loginVal == true) ? true : false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  size: 30.0,
                  color: accentColor,
                ),
                hintText: text,
                hintStyle: TextStyle(height: 1.2, fontSize: 15.0),
                suffixIcon: pass == true
                    ? IconButton(
                        icon: (controller.loginVal == true)
                            ? Icon(
                                LineAwesomeIcons.eye,
                                size: 30.0,
                                color: accentColor,
                              )
                            : Icon(
                                LineAwesomeIcons.eye_slash,
                                color: accentColor,
                              ),
                        onPressed: () {
                          controller.hidePassword();
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
    return GetBuilder<AuthViewModel>(
      init: AuthViewModel(),
      builder: (controller) => Scaffold(
        key: globalKey,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 10.0, left: 10.0),
            child: controller.loading.value
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ),
                  )
                : GetBuilder<AuthViewModel>(
                    init: Get.find(),
                    builder: (controller) => ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              'تسجيل الدخول',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 19.0,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              'مرحبا بعودتك',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildForm(
                                  'اسم المستخدم', Icons.person, false, context),
                              buildForm(
                                  'كلمة المرور', Icons.lock, true, context),
                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: ErrorLine(
                                  errors: controller.loginErrors,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: SizedBox(
                                  height: 65.0,
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: MaterialButton(
                                    onPressed: () async {
                                      // controller.setLoadingToTrue();
                                      if (_formKey.currentState.validate() &&
                                          controller.loginErrors.isEmpty) {
                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  'google.com');
                                          if (result.isNotEmpty &&
                                              result[0].rawAddress.isNotEmpty) {
                                            _formKey.currentState.save();
                                            await controller.login(context);
                                          }
                                        } on SocketException catch (_) {
                                          globalKey.currentState.showSnackBar(
                                              controller.snackBar);
                                        }
                                      }
                                    },
                                    color: primaryColor,
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
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
                  ),
          ),
        ),
      ),
    );
  }
}
