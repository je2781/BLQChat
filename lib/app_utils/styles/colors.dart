import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

//Primary Colors
const psColorPrimary50 = Color.fromRGBO(241, 193, 17, 0.05);
const psColorPrimary100 = Color.fromRGBO(241, 193, 17, 0.1);
const psColorPrimary200 = Color.fromRGBO(241, 193, 17, 0.2);
const psColorPrimary300 = Color.fromRGBO(241, 193, 17, 0.3);
const psColorPrimary400 = Color.fromRGBO(241, 193, 17, 0.4);
const psColorPrimary500 = Color.fromRGBO(241, 193, 17, 0.5);
const psColorPrimary600 = Color.fromRGBO(241, 193, 17, 0.6);
const psColorPrimary700 = Color.fromRGBO(241, 193, 17, 0.7);
const psColorPrimary800 = Color.fromRGBO(241, 193, 17, 0.8);
const psColorPrimary900 = Color.fromRGBO(241, 193, 17, 0.9);
const psColorPrimary1000 = Color.fromRGBO(241, 193, 17, 1); // #F1C111

//Primary Material Color Map
const Map<int, Color> swatch = {
  50: psColorPrimary50,
  100: psColorPrimary100,
  200: psColorPrimary200,
  300: psColorPrimary300,
  400: psColorPrimary400,
  500: psColorPrimary500,
  600: psColorPrimary600,
  700: psColorPrimary700,
  800: psColorPrimary800,
  900: psColorPrimary900,
};

const MaterialColor psPrimaryColor = MaterialColor(0xFFF1C111, swatch);

//Black Colors
const psBlack1 = Color.fromRGBO(25, 28, 28, 1); // #191C1C
const psBlack2 = Color.fromRGBO(2, 2, 2, 1); // #020202
const psBlack3 = Color.fromRGBO(4, 4, 4, 1); // #040404
const psWhite = Color.fromRGBO(255, 255, 255, 1); // #FFFFFF

//State Colors
const psSuccess = Color.fromRGBO(57, 181, 73, 1);
const psError = Color.fromRGBO(245, 2, 2, 1);
const psWarning = Color.fromRGBO(241, 193, 17, 1); // #F1C111
const psInfo = Color.fromRGBO(66, 139, 193, 1);

//Alternate State Colors
const psSuccessBg = Color.fromRGBO(57, 181, 73, 0.1);
const psErrorBg = Color.fromRGBO(245, 2, 2, 0.1);
const psWarningBg = Color.fromRGBO(241, 193, 17, 0.1); // #F1C111
const psInfoBg = Color.fromRGBO(66, 139, 193, 0.1);

//Grey Colors
const psGrey1 = Color.fromRGBO(66, 66, 66, 1); // #424242
const psGrey2 = Color.fromRGBO(113, 113, 113, 1); // #717171
const psGrey3 = Color.fromRGBO(161, 161, 161, 1); // #A1A1A1
const psGrey4 = Color.fromRGBO(187, 187, 187, 1); // #BBBBBB
const psGrey5 = Color.fromRGBO(208, 208, 208, 1); // #D0D0D0
const psGrey6 = Color.fromRGBO(239, 241, 240, 1); // #EFF1F0;
Color psGrey7 = HexColor("FAFCFC"); // #EFF1F0;

//Shadow
const BoxShadow psBoxShadow =
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.24), blurRadius: 24);
