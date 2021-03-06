import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/student_profile_viewmodel.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class StudentProfile extends StatelessWidget {
  final UserModel currentUser;
  StudentProfile({this.currentUser});
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentProfileViewModel>(
      init: StudentProfileViewModel(),
      builder: (controller) => controller.loading.value
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            )
          : GetBuilder<StudentProfileViewModel>(
              init: Get.find(),
              builder: (controller) => Scaffold(
                key: controller.globalKey,
                body: SingleChildScrollView(
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 100.0, left: 15.0, right: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream:
                              _usersCollection.doc(currentUser.id).snapshots(),
                          builder: (context, snapshot) => !snapshot.hasData
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(primaryColor),
                                )
                              : CustomText(
                                  text: snapshot.data['name'],
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0,
                                ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 30.0, top: 60.0),
                          child: CustomText(
                            text: '?????????? ??????????',
                            fontWeight: FontWeight.bold,
                            alignment: Alignment.topRight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 30.0, left: 30.0, top: 5.0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: controller.nameController,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                    onPressed: () async {
                                      try {
                                        final result =
                                            await InternetAddress.lookup(
                                                'google.com');
                                        if (result.isNotEmpty &&
                                            result[0].rawAddress.isNotEmpty) {
                                          await controller.updateName();
                                        }
                                      } on SocketException catch (_) {
                                        controller.globalKey.currentState
                                            .showSnackBar(controller.snackBar);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: accentColor,
                                      size: 40.0,
                                    ),
                                  ),
                                  errorText: controller.validName
                                      ? null
                                      : '???? ???????? ???????? ???? ?????????? ???? ?????? ???? ?????????? ????????',
                                  hintText:
                                      '???????? ?????????? ???????????? ?????? ???? ???????? ?????????? ????',
                                  hintTextDirection: TextDirection.rtl,
                                  hintStyle: TextStyle(fontSize: 14.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 30.0, top: 60.0),
                          child: CustomText(
                            text: '?????????? ?????????? ??????????',
                            fontWeight: FontWeight.bold,
                            alignment: Alignment.topRight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 30.0, left: 30.0, top: 5.0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: controller.passwordController,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                    onPressed: () async {
                                      try {
                                        final result =
                                            await InternetAddress.lookup(
                                                'google.com');
                                        if (result.isNotEmpty &&
                                            result[0].rawAddress.isNotEmpty) {
                                          await controller.updatePassword();
                                        }
                                      } on SocketException catch (_) {
                                        controller.globalKey.currentState
                                            .showSnackBar(controller.snackBar);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: accentColor,
                                      size: 40.0,
                                    ),
                                  ),
                                  errorText: controller.validPassword
                                      ? null
                                      : '???? ???????? ???????? ???? ?????????? ?????????? ???? ?????? ???? ?????? ????????',
                                  hintText:
                                      '???????? ?????????? ?????????? ???????????? ?????? ???? ???????? ?????????? ????',
                                  hintTextDirection: TextDirection.rtl,
                                  hintStyle: TextStyle(fontSize: 14.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 210.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () {
                              controller.signOut();
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 30.0,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '?????????? ????????????',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 23.0),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 20.0),
                        //   child: CustomButton(
                        //     text: '?????????? ????????????',
                        //     buttonColor: accentColor,
                        //     textColor: Colors.white,
                        //     width: MediaQuery.of(context).size.width * 0.4,
                        //     height: 50.0,
                        //     onPressed: () {
                        //       controller.signOut();
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
