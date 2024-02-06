import 'dart:convert';

import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:blq_chat/app_utils/widgets/spacing.dart';
import 'package:blq_chat/utils/ps_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Minute extends StatefulWidget {
  final List minsList;
  Minute(this.minsList);

  @override
  State<Minute> createState() => _MinuteState();
}

class _MinuteState extends State<Minute> {
  dynamic _currentUserId = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      //getting instance of local storage
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('userData')) {
        return;
      }

      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      setState(() {
        _currentUserId = extractedUserData['userId'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.minsList
            .map((mins) => Row(
                  mainAxisAlignment: mins.sender.id == _currentUserId
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mins.sender.id != _currentUserId
                            ? Container(
                                margin: EdgeInsets.only(top: 18),
                                child: mins.sender.profileUrl.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            mins.sender.profileUrl),
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundColor: blqGrey3,
                                      ),
                              )
                            : const SizedBox.shrink(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 18, bottom: 0, left: 8, right: 8),
                              width: 140,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: mins.sender.id == _currentUserId
                                    ? Theme.of(context).colorScheme.secondary
                                    : HexColor('#1a1a1a'),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(24),
                                  bottomRight: const Radius.circular(24),
                                  topLeft: mins.sender.id == _currentUserId
                                      ? const Radius.circular(24)
                                      : const Radius.circular(6),
                                  topRight: mins.sender.id == _currentUserId
                                      ? const Radius.circular(6)
                                      : const Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText(
                                      mins.sender.id == _currentUserId
                                          ? 'Josh Eze'
                                          : mins.sender.name.isEmpty
                                              ? 'Test'
                                              : mins.sender.name,
                                      weight: FontWeight.bold,
                                      color: mins.sender.id == _currentUserId
                                          ? blqWhite
                                          : blqGrey3,
                                      size: 14),
                                  const Spacing.smallHeight(),
                                  Text(
                                    mins.message ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            mins.sender.id == _currentUserId
                                ? const SizedBox.shrink()
                                : sText(
                                    DateFormat.jm().format(context
                                        .convertUnixToDateTime(mins.createdAt)),
                                    color: blqGrey3,
                                    size: 12),
                          ],
                        )
                      ],
                    ),
                  ],
                ))
            .toList());
  }
}
