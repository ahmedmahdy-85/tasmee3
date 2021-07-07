import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/view_model/control_view_model.dart';
import 'authentication/login_page.dart';

class ControlView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlViewModel>(
      init: ControlViewModel(),
      builder: (controller) => controller.savedUser == null
          ? LoginScreen()
          : GetBuilder<ControlViewModel>(
              init: Get.find(),
              builder: (controller) => Scaffold(
                body: controller.savedUser.isAdmin
                    ? controller.adminCurrentScreen
                    : controller.savedUser.isTeacher
                        ? controller.teacherCurrentScreen
                        : controller.studentCurrentScreen,
                bottomNavigationBar: controller.savedUser.isAdmin
                    ? adminBottomNavigationBar()
                    : controller.savedUser.isTeacher
                        ? teacherBottomNavigationBar()
                        : studentBottomNavigationBar(),
              ),
            ),
    );
  }

  Widget teacherBottomNavigationBar() {
    return GetBuilder<ControlViewModel>(
      init: Get.find(),
      builder: (controller) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  'الصفحة الرئيسية',
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.home,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  'مجموعتي',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.group_add,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  'احصائيات اليوم',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.pie_chart,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  'احصائيات المجموعة',
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.bar_chart_sharp,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  'احصائيات الطالب',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  LineAwesomeIcons.bar_chart_o,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                child: Text(
                  'الصفحة الشخصية',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.person,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
        ],
        currentIndex: controller.teacherNavigatorValue,
        onTap: (index) {
          controller.teacherChangeSelectedValue(index);
        },
        elevation: 0.0,
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: Colors.black,
      ),
    );
  }

  Widget studentBottomNavigationBar() {
    return GetBuilder<ControlViewModel>(
      init: Get.find(),
      builder: (controller) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                child: Text(
                  'الصفحة الرئيسية',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Icon(
                  Icons.home,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 5.0),
                child: Text(
                  'احصائياتي',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Icon(
                  LineAwesomeIcons.bar_chart_o,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
                child: Text(
                  'الصفحة الشخصية',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Icon(
                  Icons.person,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
        ],
        currentIndex: controller.studentNavigatorValue,
        onTap: (index) {
          controller.studentChangeSelectedValue(index);
        },
        elevation: 0.0,
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget adminBottomNavigationBar() {
    return GetBuilder<ControlViewModel>(
      init: Get.find(),
      builder: (controller) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 10.0),
                child: Text(
                  'الصفحة الرئيسية',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Icon(
                  Icons.home,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
          BottomNavigationBarItem(
              activeIcon: Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                child: Text(
                  'الصفحة الشخصية',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
              label: '',
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Icon(
                  Icons.person,
                  size: 40.0,
                  color: accentColor,
                ),
              )),
        ],
        currentIndex: controller.adminNavigatorValue,
        onTap: (index) {
          controller.adminChangeSelectedValue(index);
        },
        elevation: 0.0,
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
