import 'dart:developer';

import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/strings.dart';
import 'package:blq_chat/ui/chat/view_model/chat_view_model.dart';
import 'package:blq_chat/ui/chat/widgets/messages.dart';
import 'package:blq_chat/ui/chat/widgets/new_message.dart';
import 'package:blq_chat/ui/chat/widgets/profile.dart';
import 'package:blq_chat/ui/chat/widgets/reorder_list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChatViewModel>(context, listen: false)
        .getUserRequest()
        .then((result) {
      if (!result) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: false,
          builder: (_) {
            return MyProfile();
          },
        );
      }
    });
    Provider.of<ChatViewModel>(context, listen: false).getChatsRequest();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent back button press.
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(BLQStrings.blqAppName),
          leading:
              IconButton(onPressed: () => {}, icon: Icon(Icons.chevron_left)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: false,
                      builder: (_) {
                        return MyProfile();
                      },
                    ),
                icon: Icon(Icons.menu))
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(
            top: 5,
          ),
          child: Column(
            children: [
              Expanded(
                child: Consumer<ChatViewModel>(builder: (_, model, ch) {
                  //extracting chats for different months
                  final monthList = Order.reorderList(model.chats, context);
                  return model.isLoading
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                          ],
                        )
                      : model.chats.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: sText(
                                    'No recent chats.\nBegin a new conversation with your contact',
                                    weight: FontWeight.bold,
                                    size: 14,
                                    color: Colors.white,
                                    align: TextAlign.center),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (_, i) {
                                  return MessagesWidget(
                                    chatsPerMonth: monthList[i],
                                  );
                                },
                                itemCount: monthList.length,
                              ),
                            );
                }),
              ),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
