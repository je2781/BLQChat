import 'dart:developer';

import 'package:blq_chat/app_utils/helper/helper.dart';
import 'package:blq_chat/app_utils/styles/strings.dart';
import 'package:blq_chat/service/sendbird_channel_handler.dart';
import 'package:blq_chat/ui/chat/view_model/chat_view_model.dart';
import 'package:blq_chat/ui/chat/widgets/messages.dart';
import 'package:blq_chat/ui/chat/widgets/new_message.dart';
import 'package:blq_chat/ui/chat/widgets/profile.dart';
import 'package:blq_chat/ui/chat/widgets/reorder_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final model = Provider.of<ChatViewModel>(context, listen: false);
    //defining event listener for updates on new messages
    SendbirdChat.addChannelHandler('new-message', MyOpenChannelHandler(model));

    model.getUserRequest().then((result) async {
      if (!result) {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          enableDrag: false,
          builder: (_) {
            return MyProfile();
          },
        );
      }
      //entering open sendbird channel to send and receive messages
      final openChannel =
          await OpenChannel.getChannel(dotenv.get('CHANNEL_URL'));
      await openChannel.enter();
      //saving channel instance in global storage for receiving messages
      model.saveChannel(openChannel);
    });
    model.getChatsRequest();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    //declaring AppBar
    final appBar = AppBar(
      title: Text(BLQStrings.blqAppName),
      leading: IconButton(onPressed: () => {}, icon: Icon(Icons.chevron_left)),
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
    );
    //extracting the available screen height for the widgets
    final availableWidgetHeight = (mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top);
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent back button press.
        return false;
      },
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: isPortrait
                    ? availableWidgetHeight * 0.88
                    : availableWidgetHeight * 0.7,
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
                              padding: const EdgeInsets.all(6),
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
                              padding: const EdgeInsets.all(6),
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
