import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/admin_model.dart';
import 'package:tasmee3/model/student_model.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/pages/control_view.dart';
import 'package:tasmee3/services/firestore_user.dart';
import 'package:tasmee3/view_model/control_view_model.dart';
import 'package:tasmee3/widgets/no_account_bottom_sheet.dart';
import 'package:tasmee3/widgets/show_bottom_sheet.dart';

class AuthViewModel extends GetxController {
  final snackBar = SnackBar(
    content: Text(
      'لا يوجد اتصال بالانترنت',
      textDirection: TextDirection.rtl,
    ),
    duration: Duration(seconds: 2),
  );
  bool loginSuccessful = false;
  bool clickable = true;
  AdminModel admin;
  List<StudentModel> students;
  final LocalStorageData localStorageData = Get.find();
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  String loginUser, loginPassword;
  bool loginVal = true;
  List<String> loginErrors = [];

  void hidePassword() {
    loginVal = !loginVal;
    update();
  }

  void loginOnSaved(bool pass, String value) {
    if (pass == false) {
      loginUser = value;
      update();
    }
    if (pass == true) {
      loginPassword = value;
      update();
    }
  }

  void loginOnChanged(String value, bool pass) {
    if (value.isNotEmpty &&
        loginErrors.contains('من فضلك اكمل البيانات الخاصة بك')) {
      loginErrors.remove('من فضلك اكمل البيانات الخاصة بك');
      update();
    }
    if (pass == true) {
      if (value.length >= 6 &&
          loginErrors.contains('الرقم السري يجب ان لا يقل عن ستة احرف')) {
        loginErrors.remove('الرقم السري يجب ان لا يقل عن ستة احرف');
        update();
      }
    }
    if (pass == false) {
      if (value.length >= 4 &&
          loginErrors.contains("اسم المستخدم يجب الا يقل عن اربعة احرف")) {
        loginErrors.remove("اسم المستخدم يجب الا يقل عن اربعة احرف");
        update();
      }
    }
  }

  void loginValidator(String value, bool pass) {
    if (value.isEmpty &&
        !loginErrors.contains('من فضلك اكمل البيانات الخاصة بك')) {
      loginErrors.add('من فضلك اكمل البيانات الخاصة بك');
      update();
    }
    if (pass == true) {
      if (value.length < 6 &&
          value.length != 0 &&
          !loginErrors.contains('الرقم السري يجب ان لا يقل عن ستة احرف')) {
        loginErrors.add('الرقم السري يجب ان لا يقل عن ستة احرف');
        update();
      }
    }
    if (pass == false) {
      if (value.length < 4 &&
          value.length != 0 &&
          !loginErrors.contains("اسم المستخدم يجب الا يقل عن اربعة احرف")) {
        loginErrors.add("اسم المستخدم يجب الا يقل عن اربعة احرف");
        update();
      }
    }
  }

  Future<void> login(BuildContext context) async {
    _loading.value = true;
    await FireStoreUser().getAdminLogin().then((value) {
      admin = (AdminModel.fromJson(value.data()));
      if (loginUser == admin.username && loginPassword == admin.password) {
        UserModel _currentUser = UserModel(
            name: admin.name,
            username: admin.username,
            password: admin.password,
            isAdmin: true,
            isTeacher: false,
            id: admin.id);
        saveUserToSharedPref(_currentUser);
        Get.find<ControlViewModel>().setSavedUser(_currentUser);
        _loading.value = false;
        loginSuccessful = true;
        update();
        Get.offAll(ControlView(),
            duration: Duration(seconds: 2), transition: Transition.rightToLeft);
        return;
      }
    });
    await FireStoreUser()
        .getLoginInfo(
      loginUser,
      loginPassword,
    )
        .then((value) async {
      if (value.isNotEmpty) {
        UserModel user = UserModel.fromJson(value[0].data());
        await saveUserToSharedPref(user);
        Get.find<ControlViewModel>().setSavedUser(user);
        _loading.value = false;
        loginSuccessful = true;
        update();
        Get.offAll(ControlView(),
            duration: Duration(seconds: 2), transition: Transition.rightToLeft);
        return;
      }
    });
    if (!loginSuccessful) {
      showBottom(
          context,
          NoAccount(
            text: 'لا يوجد حساب من فضلك قم بتسجيل حساب',
          ));
      _loading.value = false;
      update();
    }
  }

  Future<void> saveUserToSharedPref(UserModel userModel) async {
    await localStorageData.setUser(userModel);
    update();
  }
}
