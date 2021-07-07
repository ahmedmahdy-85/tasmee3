import 'package:get/get.dart';
import 'package:tasmee3/view_model/StudentDailyStatistics.dart';
import 'package:tasmee3/view_model/admin_profile_view_model.dart';
import 'package:tasmee3/view_model/admin_view_model.dart';
import 'package:tasmee3/view_model/auth_view_model.dart';
import 'package:tasmee3/view_model/group_statistics_viewModel.dart';
import 'package:tasmee3/view_model/manage_students_viewmodel.dart';
import 'package:tasmee3/view_model/student_profile_viewmodel.dart';
import 'package:tasmee3/view_model/day_statistics_viewModel.dart';
import 'package:tasmee3/view_model/student_review_view_model.dart';
import 'package:tasmee3/view_model/teacher_profile_view_model.dart';
import 'package:tasmee3/view_model/student_home_viewmodel.dart';
import 'package:tasmee3/view_model/teacher_home_viewmodel.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => TeacherViewModel(), fenix: true);
    Get.lazyPut(() => StudentViewModel());
    Get.lazyPut(() => AdminViewModel());
    Get.lazyPut(() => ProfileViewModel());
    Get.lazyPut(() => AdminProfileViewModel());
    Get.lazyPut(() => ManageStudentsViewModel());
    Get.lazyPut(() => StudentProfileViewModel());
    Get.lazyPut(() => TeacherDayStatisticsViewModel());
    Get.lazyPut(() => GroupStatisticsViewModel());
    Get.lazyPut(() => StudentReviewViewModel());
    Get.lazyPut(() => StudentStatisticsViewModel());
  }
}
