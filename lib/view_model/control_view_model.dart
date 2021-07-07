import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tasmee3/helper/local_storage_data.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/pages/admin/admin.dart';
import 'package:tasmee3/pages/admin/admin_profile.dart';
import 'package:tasmee3/pages/student/student_home_page.dart';
import 'package:tasmee3/pages/student/student_profile.dart';
import 'package:tasmee3/pages/student/student_statistics.dart';
import 'package:tasmee3/pages/teacher/my_group.dart';
import 'package:tasmee3/pages/teacher/student_review.dart';
import 'package:tasmee3/pages/teacher/teacher_daily_statistics.dart';
import 'package:tasmee3/pages/teacher/teacher_group_statistics.dart';
import 'package:tasmee3/pages/teacher/teacher_home_page.dart';
import 'package:tasmee3/pages/teacher/teacher_profile.dart';

class ControlViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  final LocalStorageData localStorageData = Get.find();

  UserModel _savedUser;
  UserModel get savedUser => _savedUser;
  int _teacherNavigatorValue = 0;
  int get teacherNavigatorValue => _teacherNavigatorValue;
  int _studentNavigatorValue = 0;
  int get studentNavigatorValue => _studentNavigatorValue;
  int _adminNavigatorValue = 0;
  int get adminNavigatorValue => _adminNavigatorValue;
  Widget _teacherCurrentScreen = TeacherHome();
  Widget get teacherCurrentScreen => _teacherCurrentScreen;
  Widget _studentCurrentScreen = StudentHome();
  Widget get studentCurrentScreen => _studentCurrentScreen;
  Widget _adminCurrentScreen = AdminHomeScreen();
  Widget get adminCurrentScreen => _adminCurrentScreen;

  void teacherChangeSelectedValue(int selectedValue) {
    _teacherNavigatorValue = selectedValue;
    switch (selectedValue) {
      case 0:
        {
          _teacherCurrentScreen = TeacherHome(
            currentUser: _savedUser,
          );
          break;
        }
      case 1:
        {
          _teacherCurrentScreen = MyGroup(
            currentUser: _savedUser,
          );
          break;
        }
      case 2:
        {
          _teacherCurrentScreen = DailyStatistics(
            currentUser: _savedUser,
          );
          break;
        }
      case 3:
        {
          _teacherCurrentScreen = GroupStatistics(
            currentUser: _savedUser,
          );
          break;
        }
      case 4:
        {
          _teacherCurrentScreen = StudentReview(
            currentUser: _savedUser,
          );
          break;
        }
      case 5:
        {
          _teacherCurrentScreen = TeacherProfile(
            currentUser: _savedUser,
          );
          break;
        }
    }
    update();
  }

  void studentChangeSelectedValue(int selectedValue) {
    _studentNavigatorValue = selectedValue;
    switch (selectedValue) {
      case 0:
        {
          _studentCurrentScreen = StudentHome(currentUser: _savedUser);
          break;
        }
      case 1:
        {
          _studentCurrentScreen = StudentStatistics(currentUser: _savedUser);
          break;
        }
      case 2:
        {
          _studentCurrentScreen = StudentProfile(
            currentUser: _savedUser,
          );
          break;
        }
    }
    update();
  }

  void adminChangeSelectedValue(int selectedValue) {
    _adminNavigatorValue = selectedValue;
    switch (selectedValue) {
      case 0:
        {
          _adminCurrentScreen = AdminHomeScreen(currentUser: _savedUser);
          break;
        }
      case 1:
        {
          _adminCurrentScreen = AdminProfileScreen(currentUser: _savedUser);
          break;
        }
    }
    update();
  }

  Future<void> getCurrentUser() async {
    await localStorageData.getUser.then((value) {
      if (value != null) {
        _savedUser = value;
      }
    });

    update();
  }

  void setSavedUser(UserModel user) {
    _savedUser = user;
  }
}
