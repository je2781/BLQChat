import 'dart:convert';

import 'package:blq_chat/app_utils/extensions/time_conversion_extension.dart';
import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:blq_chat/app_utils/widgets/spacing.dart';
import 'package:blq_chat/utils/ps_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  dynamic _currentUser = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      //getting instance of local storage
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('userData') || !prefs.containsKey('messageData')) {
        return;
      }

      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      final extractedMessageData =
          json.decode(prefs.getString('messageData')!) as Map<String, dynamic>;

      setState(() {
        _currentUserId = extractedUserData['userId'];
        _currentUser = extractedMessageData['user'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

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
                                child: mins.sender.profileUrl.isNotEmpty &&
                                        mins.sender.profileUrl
                                            .startsWith('https')
                                    ? CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            CachedNetworkImageProvider(mins
                                                    .sender.profileUrl ??
                                                'https://www.seti.org/sites/default/files/styles/original/public/2019-09/Zork%20alien%20head%20PPR.jpg?itok=T7eTYzCZ'),
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundImage: CachedNetworkImageProvider(
                                            'https://www.seti.org/sites/default/files/styles/original/public/2019-09/Zork%20alien%20head%20PPR.jpg?itok=T7eTYzCZ'),
                                      ),
                              )
                            : const SizedBox.shrink(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 18, bottom: 0, left: 8, right: 8),
                              width: isPortrait ? 160 : 250,
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
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      sText(
                                          mins.sender.id == _currentUserId
                                              ? _currentUser
                                              : mins.sender.name.isEmpty
                                                  ? 'Test'
                                                  : mins.sender.name,
                                          weight: FontWeight.bold,
                                          align: TextAlign.start,
                                          maxLines: 1,
                                          color:
                                              mins.sender.id == _currentUserId
                                                  ? blqWhite
                                                  : blqGrey3,
                                          size: 14),
                                      if (mins.sender.id != _currentUserId)
                                        Spacing.smallWidth(),
                                      mins.sender.isActive &&
                                              mins.sender.id != _currentUserId
                                          ? Icon(
                                              Icons.circle,
                                              color: blqSuccess,
                                              size: 8,
                                            )
                                          : SizedBox.shrink()
                                    ],
                                  ),
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
