import 'package:flutter/material.dart';
import 'package:tasmee3/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final Function onPressed;
  final String text;
  final Color textColor;
  final Color buttonColor;
  final double fontSize;
  final double height;

  CustomButton(
      {this.width,
      this.onPressed,
      this.text,
      this.textColor,
      this.fontSize,
      this.height,
      this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
        ),
        onPressed: onPressed,
        child: CustomText(
          text: text,
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
