import 'package:flutter/material.dart';

import '../consts/app_color_constants.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 57,
    this.bgColor = const Color.fromARGB(179, 20, 10, 217),
    this.fontSize = 18,
    this.textColor = Colors.white,
    required this.active,
  });

  final String text;

  final double height;
  final double fontSize;
  final void Function() onTap;
  final Color bgColor;
  final Color textColor;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: active ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: bgColor,
            border: Border.all(color: Colors.grey)),
        height: height,
        child: Center(
          child: active
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      AppColorsConstants.whiteColor),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
