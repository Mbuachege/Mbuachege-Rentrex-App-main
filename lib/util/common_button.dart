import 'package:flutter/material.dart';
import 'package:prime_travel_flutter_ui_kit/util/font_family.dart';
import 'package:prime_travel_flutter_ui_kit/util/size_config.dart';
import 'colors.dart';

// ignore: must_be_immutable
class ButtonCommon extends StatelessWidget {
  String? text;
  VoidCallback? onTap;
  Color? textColor;
  Color? buttonColor;
  ButtonCommon(
      {super.key, this.text, this.buttonColor, this.textColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeFile.height52,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeFile.height8),
        color: buttonColor ?? ColorFile.appColor,
      ),
      child: Text(
        text!,
        style: TextStyle(
          color: textColor ?? ColorFile.whiteColor,
          fontFamily: satoshiMedium,
          fontWeight: FontWeight.w500,
          fontSize: SizeFile.height18,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ShortButton extends StatelessWidget {
  String? text;
  Color? textColor;
  Color? buttonColor;
  double? width;
  ShortButton(
      {super.key, this.text, this.textColor, this.buttonColor, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeFile.height48,
      width: width ?? MediaQuery.of(context).size.width / 2.4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(SizeFile.height10),
      ),
      child: Text(text ?? "",
          style: TextStyle(
              color: textColor ?? ColorFile.whiteColor,
              fontFamily: satoshiMedium,
              fontWeight: FontWeight.w500,
              fontSize: SizeFile.height18)),
    );
  }
}
