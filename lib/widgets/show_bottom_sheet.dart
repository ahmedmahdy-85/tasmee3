import 'package:flutter/material.dart';

showBottom(BuildContext context, Widget widget) {
  showModalBottomSheet(
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: widget,
          )));
}
