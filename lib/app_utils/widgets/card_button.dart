import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/app_dimensions.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color textColor;
  final String buttonText;
  final Color buttonColor;
  final double? minWidth;
  const CardButton({
    Key? key,
    required this.onPressed,
    required this.textColor,
    this.minWidth,
    required this.buttonText,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        elevation: 0,
        height: 50,
        minWidth: minWidth ?? 380,
        onPressed: onPressed,
        textColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimension.small * 1.25),
        ),
        splashColor: const Color.fromRGBO(254, 237, 177, 1),
        color: buttonColor,
        child: sText(
          buttonText,
          weight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
