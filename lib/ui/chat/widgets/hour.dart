import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:blq_chat/app_utils/widgets/spacing.dart';
import 'package:blq_chat/ui/chat/widgets/min.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Hour extends StatelessWidget {
  final List hoursList;
  Hour(this.hoursList);

  @override
  Widget build(BuildContext context) {
    final minsList = List.generate(60, (index) => []);
    List updatedminsList = [];

    for (var i = 0; i < minsList.length; i++) {
      minsList[i].addAll(hoursList.where(
          (day) => context.convertUnixToDateTime(day.createdAt).minute == i));
    }

    updatedminsList
        .addAll(minsList.where((element) => element.isNotEmpty).toList());

    return Column(
        children: updatedminsList
            .map(
              (minsList) => Minute(minsList),
            )
            .toList());
  }
}
