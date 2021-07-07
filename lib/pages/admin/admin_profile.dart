import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/model/user_model.dart';
import 'package:tasmee3/view_model/admin_profile_view_model.dart';
import 'package:tasmee3/widgets/custom_button.dart';

class AdminProfileScreen extends StatelessWidget {
  final UserModel currentUser;
  AdminProfileScreen({this.currentUser});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminProfileViewModel>(
      init: AdminProfileViewModel(),
      builder: (controller) => Scaffold(
        body: Center(
          child: CustomButton(
            text: 'تسجيل الخروج',
            buttonColor: accentColor,
            textColor: Colors.white,
            width: MediaQuery.of(context).size.width * 0.4,
            height: 50.0,
            onPressed: () {
              controller.signOut();
            },
          ),
        ),
      ),
    );
  }
}
