import 'dart:developer';

import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Order {
  static List reorderList(List<Chat> chats, BuildContext context) {
    const numOfMonths = 12;

    final monthsList = List.generate(numOfMonths, (index) => []);

    for (var i = 0; i < monthsList.length; i++) {
      monthsList[i].addAll(
        chats
            .where(
              (chat) {
                var updatedDateTime =
                    context.convertUnixToDateTime(chat.createdAt!);
                return updatedDateTime.month == i + 1 &&
                    updatedDateTime.year < 2024;
              },
            )
            .toList()
            .reversed,
      );
      monthsList[i].addAll(
        chats
            .where(
              (chat) {
                var updatedDateTime =
                    context.convertUnixToDateTime(chat.createdAt!);
                return updatedDateTime.month == i + 1 &&
                    updatedDateTime.year == 2024;
              },
            )
            .toList()
            .reversed,
      );
    }

    final updatedMonthsList =
        monthsList.where((element) => element.isNotEmpty).toList();

    return updatedMonthsList;
  }
}
