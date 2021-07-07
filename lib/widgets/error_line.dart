import 'package:flutter/material.dart';

class ErrorLine extends StatelessWidget {
  final List<String> errors;
  ErrorLine({@required this.errors});

  Widget errorLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        right: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12.0,
            ),
            textAlign: TextAlign.end,
          ),
          SizedBox(
            width: 2.0,
          ),
          Icon(
            Icons.error,
            color: Colors.red,
            size: 18.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          List.generate(errors.length, (index) => errorLine(errors[index])),
    );
  }
}
