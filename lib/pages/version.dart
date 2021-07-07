import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasmee3/helper/consts.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class VerifyVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomText(
          text: 'تم ايقاف هذه النسخة من فضلك قم بتحميل اخر تحديث ',
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }
}
