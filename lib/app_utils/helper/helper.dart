import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:blq_chat/app_utils/widgets/spacing.dart';
import 'package:blq_chat/ui/chat/view_model/chat_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

List<BoxShadow> elevation({required Color color, required int elevation}) {
  return [
    BoxShadow(
        color: color.withOpacity(0.6),
        offset: const Offset(0.0, 4.0),
        blurRadius: 3.0 * elevation,
        spreadRadius: -1.0 * elevation),
    BoxShadow(
        color: color.withOpacity(0.44),
        offset: const Offset(0.0, 1.0),
        blurRadius: 2.2 * elevation,
        spreadRadius: 1.5),
    BoxShadow(
        color: color.withOpacity(0.12),
        offset: const Offset(0.0, 1.0),
        blurRadius: 4.6 * elevation,
        spreadRadius: 0.0),
  ];
}

const Color sBlueGray = Color(0xFFb4bbc9);
const Color solonGray200 = Color(0xFFdadcdf);
const Color solonGray300 = Color(0xFFADB5BD);
const Color solonGray400 = Color(0xFF9ea6ad);
const Color solonGray500 = Color(0xFF757b81);
const Color solonGray600 = Color(0xFF5b5f64);
const Color solonGray700 = Color(0xFF495057);

const Color darkColor = Color(0xFF253341);

Color sDarkGray = dDarkText.withOpacity(0.8);
Color sGray = dDarkText.withOpacity(0.4);
const dDarkText = Color(0xFF1D1D1D);
const Color dTurquoise = Color(0xFF0CB8B6);
const Color dPurple = Color(0xFF9F5DE2);
const Color dMiddleBlue = Color(0xFF5C86CE);
const Color dPurpleGradientLeft = Color(0xFF7A08FA);
const Color dPurpleGradientRight = Color(0xFFAD3BFC);
const Color dRedGradientRight = Color(0xFFE5366A);
const Color dRedGradientLeft = Color(0xFFFE806F);

const appLightGray = Color(0xFFE7ECF2);
const appMainLimeGreen = Color(0xFF96a038);
const appMainLimeGreen2 = Color(0xFF75bf43);
const appMainGreen = Color(0xFF00C853);
const appMainPink = Color(0xFFb81e4f);
const appMainViolet = Color(0xFF87449a);
const appMainDarkGrey = Color(0xFF253d47);
const appMainOrange = Color(0xFFba5927);
const appGray = Color(0xFFadb4b9);
const appDarkText = Color(0xFF2F2F2F);
const appBlackText = Color(0xFF191C1C);
const appBlueText = Color(0xFF428BC1);
const appYellowText = Color(0xFFF1C111);
const bgColor = Color(0xFFF2F2F7);

Widget sText(String? word,
    {double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = Colors.black,
    TextAlign align = TextAlign.left,
    int maxLines = 5,
    double? lHeight = 1.2,
    String family = 'Poppins',
    FontStyle style = FontStyle.normal,
    int shadow = 0}) {
  return Text(
    word ?? '...',
    softWrap: true,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    textAlign: align,
    style: TextStyle(
      height: lHeight,
      fontStyle: style,
      color: color,
      fontFamily: family,
      fontSize: size,
      overflow: TextOverflow.ellipsis,
      fontWeight: weight,
      shadows:
          shadow > 0 ? elevation(color: Colors.black38, elevation: shadow) : [],
    ),
  );
}

Widget sText2(String? word,
    {double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = solonGray700,
    TextAlign align = TextAlign.left,
    int maxLines = 5,
    double? lHeight = 1.2,
    String family = 'ProximaRegular',
    int shadow = 0}) {
  return Text(
    word ?? '...',
    softWrap: true,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    textAlign: align,
    style: TextStyle(
      height: lHeight,
      color: color,
      fontFamily: 'ProximaRegular',
      fontSize: size,
      fontWeight: weight,
      shadows:
          shadow > 0 ? elevation(color: Colors.black38, elevation: shadow) : [],
    ),
  );
}

toastMessage(String text, {bool long = false}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      backgroundColor: dDarkText,
      textColor: Colors.white);
}

navigateTo(BuildContext context, Widget target,
    {bool replace = false,
    PageTransitionType anim = PageTransitionType.fade,
    int millis = 300,
    bool opaque = false}) {
  if (!replace) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: opaque,
        pageBuilder: (BuildContext context, animation, secondaryAnimation) =>
            target,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        }));
  } else {
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.size,
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.bottomCenter,
            child: target));
  }
}
