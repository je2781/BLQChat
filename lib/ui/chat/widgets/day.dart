import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/ui/chat/widgets/hour.dart';
import 'package:flutter/material.dart';

class Day extends StatelessWidget {
  final List dayList;
  const Day(this.dayList);

  @override
  Widget build(BuildContext context) {
    final hoursList = List.generate(24, (index) => []);
    List updatedHoursList = [];

    for (var i = 0; i < hoursList.length; i++) {
      hoursList[i].addAll(dayList.where(
          (day) => context.convertUnixToDateTime(day.createdAt).hour == i));
    }

    updatedHoursList
        .addAll(hoursList.where((element) => element.isNotEmpty).toList());

    return Column(
      children: updatedHoursList.map((hourList) => Hour(hourList)).toList(),
    );
  }
}
