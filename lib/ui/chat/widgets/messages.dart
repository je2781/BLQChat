import 'dart:developer';
import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:blq_chat/app_utils/widgets/spacing.dart';
import 'package:blq_chat/data/response/chat/chat.dart';
import 'package:blq_chat/ui/chat/widgets/day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesWidget extends StatefulWidget {
  final List? chatsPerMonth;
  MessagesWidget({
    this.chatsPerMonth,
  });

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    List updatedDaysList = [];
    final daysList = List.generate(31, (index) => []);

    for (var i = 0; i < daysList.length; i++) {
      daysList[i].addAll(widget.chatsPerMonth!.where((chat) =>
          context.convertUnixToDateTime(chat.createdAt).day == i + 1));
    }

    updatedDaysList
        .addAll(daysList.where((element) => element.isNotEmpty).toList());

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: updatedDaysList
            .map(
              (dayList) => Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Divider(thickness: 1, color: blqGrey3),
                        ),
                        const Spacing.tinyWidth(),
                        sText(
                            DateFormat.MMMd().format(context
                                .convertUnixToDateTime(dayList[0].createdAt)),
                            size: isLandscape ? 16 : 15,
                            color: Colors.white,
                            weight: FontWeight.bold),
                        const Spacing.tinyWidth(),
                        const Expanded(
                          flex: 1,
                          child: Divider(thickness: 1, color: blqGrey3),
                        ),
                      ],
                    ),
                  ),
                  Day(dayList),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
