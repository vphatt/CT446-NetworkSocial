import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final String text;
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  const FollowButton(
      {Key? key,
      required this.text,
      this.function,
      required this.backgroundColor,
      required this.borderColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 50,
        //padding: EdgeInsets.symmetric(vertical: ),
        child: TextButton(
          onPressed: function,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ),
        ));
  }
}
