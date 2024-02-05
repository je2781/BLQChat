import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:blq_chat/app_utils/widgets/spacing.dart';
import 'package:blq_chat/utils/ps_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Minute extends StatelessWidget {
  final List minsList;
  Minute(this.minsList);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: minsList
            .map((mins) => Row(
                  mainAxisAlignment: mins.sender.id == 'Josh012'
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mins.sender.id != 'Josh012'
                            ? Container(
                                margin: EdgeInsets.only(top: 18),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(mins
                                          .sender.profileUrl ??
                                      "https://neoslibraries.ca/wp-content/uploads/2/files/sites/2/2023/02/2021-report-teaser.jpg"),
                                ),
                              )
                            : const SizedBox.shrink(),
                        Container(
                          margin: EdgeInsets.only(
                              top: 18, bottom: 0, left: 12, right: 12),
                          width: 140,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: mins.sender.id == 'Josh012'
                                ? Theme.of(context).colorScheme.secondary
                                : HexColor('#1a1a1a'),
                            borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(18),
                              bottomRight: const Radius.circular(18),
                              topLeft: mins.sender.id == 'Josh012'
                                  ? const Radius.circular(18)
                                  : const Radius.circular(6),
                              topRight: mins.sender.id == 'Josh012'
                                  ? const Radius.circular(6)
                                  : const Radius.circular(18),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: mins.message.contains('<') ? 13 : 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sText(
                                    mins.sender.id == 'Josh012'
                                        ? 'Josh Eze'
                                        : mins.sender.name.isEmpty
                                            ? 'Test'
                                            : mins.sender.name,
                                    weight: FontWeight.bold,
                                    color: psGrey3,
                                    size: 14),
                                const Spacing.meduimHeight(),
                                Text(
                                  mins.message,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        sText(
                            DateFormat.jm().format(
                                context.convertUnixToDateTime(mins.createdAt)),
                            color: psGrey3,
                            size: 12),
                      ],
                    ),
                  ],
                ))
            .toList());
  }
}
