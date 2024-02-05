import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

//Primary Colors
const blqColorPrimary50 = Color.fromRGBO(241, 193, 17, 0.05);
const blqColorPrimary100 = Color.fromRGBO(241, 193, 17, 0.1);
const blqColorPrimary200 = Color.fromRGBO(241, 193, 17, 0.2);
const blqColorPrimary300 = Color.fromRGBO(241, 193, 17, 0.3);
const blqColorPrimary400 = Color.fromRGBO(241, 193, 17, 0.4);
const blqColorPrimary500 = Color.fromRGBO(241, 193, 17, 0.5);
const blqColorPrimary600 = Color.fromRGBO(241, 193, 17, 0.6);
const blqColorPrimary700 = Color.fromRGBO(241, 193, 17, 0.7);
const blqColorPrimary800 = Color.fromRGBO(241, 193, 17, 0.8);
const blqColorPrimary900 = Color.fromRGBO(241, 193, 17, 0.9);
const blqColorPrimary1000 = Color.fromRGBO(241, 193, 17, 1); // #F1C111

//Primary Material Color Map
const Map<int, Color> swatch = {
  50: blqColorPrimary50,
  100: blqColorPrimary100,
  200: blqColorPrimary200,
  300: blqColorPrimary300,
  400: blqColorPrimary400,
  500: blqColorPrimary500,
  600: blqColorPrimary600,
  700: blqColorPrimary700,
  800: blqColorPrimary800,
  900: blqColorPrimary900,
};

const MaterialColor blqPrimaryColor = MaterialColor(0xFFF1C111, swatch);

//Black Colors
const blqBlack1 = Color.fromRGBO(25, 28, 28, 1); // #191C1C
const blqBlack2 = Color.fromRGBO(2, 2, 2, 1); // #020202
const blqBlack3 = Color.fromRGBO(4, 4, 4, 1); // #040404
const blqWhite = Color.fromRGBO(255, 255, 255, 1); // #FFFFFF

//State Colors
const blqSuccess = Color.fromRGBO(57, 181, 73, 1);
const blqError = Color.fromRGBO(245, 2, 2, 1);
const blqWarning = Color.fromRGBO(241, 193, 17, 1); // #F1C111
const blqInfo = Color.fromRGBO(66, 139, 193, 1);

//Alternate State Colors
const blqSuccessBg = Color.fromRGBO(57, 181, 73, 0.1);
const blqErrorBg = Color.fromRGBO(245, 2, 2, 0.1);
const blqWarningBg = Color.fromRGBO(241, 193, 17, 0.1); // #F1C111
const blqInfoBg = Color.fromRGBO(66, 139, 193, 0.1);

//Grey Colors
const blqGrey1 = Color.fromRGBO(66, 66, 66, 1); // #424242
const blqGrey2 = Color.fromRGBO(113, 113, 113, 1); // #717171
const blqGrey3 = Color.fromRGBO(161, 161, 161, 1); // #A1A1A1
const blqGrey4 = Color.fromRGBO(187, 187, 187, 1); // #BBBBBB
const blqGrey5 = Color.fromRGBO(208, 208, 208, 1); // #D0D0D0
const blqGrey6 = Color.fromRGBO(239, 241, 240, 1); // #EFF1F0;
Color blqGrey7 = HexColor("FAFCFC"); // #EFF1F0;

//Shadow
const BoxShadow blqBoxShadow =
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.24), blurRadius: 24);
