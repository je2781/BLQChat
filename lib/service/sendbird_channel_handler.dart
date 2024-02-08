import 'package:blq_chat/ui/chat/view_model/chat_view_model.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class MyOpenChannelHandler extends OpenChannelHandler {
  ChatViewModel model;

  MyOpenChannelHandler(this.model);

  @override
  onMessageReceived(BaseChannel channel, BaseMessage message) {
    model.saveNewMessage(message.messageId);
  }
}
