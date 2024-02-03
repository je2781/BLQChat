import 'dart:io';
import 'package:blq_chat/ui/chat/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'app_utils/styles/strings.dart';

class BLQChat extends StatelessWidget {
  const BLQChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ChatViewModel(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: PSStrings.psAppName,
          theme: ThemeData(
            primarySwatch: Colors.grey,
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              secondary: Colors.pinkAccent,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.black,
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyMedium: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
            buttonTheme: ButtonThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textTheme: ButtonTextTheme.primary,
              buttonColor: Colors.pink,
            ),
          ),
          home: const BLQChat()),
    );
  }
}
