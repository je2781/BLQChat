import 'dart:io';
import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:blq_chat/cubits/chat_cubit.dart';
import 'package:blq_chat/ui/chat/view_model/chat_view_model.dart';
import 'package:blq_chat/ui/chat/views/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'app_utils/styles/strings.dart';

class BLQChat extends StatelessWidget {
  const BLQChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(context),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: BLQStrings.blqAppName,
          theme: ThemeData(
            primarySwatch: Colors.grey,
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              secondary: Colors.pinkAccent,
            ),
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: HexColor('#323232'), width: 2),
              ),
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
          home: ChatScreen()),
    );
  }
}
