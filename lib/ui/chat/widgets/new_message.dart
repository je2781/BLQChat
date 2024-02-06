import 'package:blq_chat/app_utils/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../view_model/chat_view_model.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _newMsg = '';
  final _controller = TextEditingController();

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    _controller.clear();

    Provider.of<ChatViewModel>(context, listen: false)
        .sendChatRequest({'message': _newMsg}, context);
    setState(() {
      _newMsg = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      decoration: BoxDecoration(color: HexColor('#131313')),
      height: isLandscape
          ? MediaQuery.of(context!).size.height * .25
          : MediaQuery.of(context).size.height * .1,
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              await Provider.of<ChatViewModel>(context, listen: false)
                  .sendFile();
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: HexColor('#1a1a1a'),
                  border: Border.all(color: HexColor('#323232'), width: 2),
                  borderRadius: BorderRadius.circular(28)),
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'New message',
                  labelStyle: TextStyle(
                      color: _newMsg.isEmpty ? blqGrey2 : Colors.white),
                  contentPadding: EdgeInsets.only(left: 24),
                  suffixIcon: Container(
                    margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: _newMsg.isEmpty
                          ? HexColor('#3a3a3a')
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                      maxHeight: 38,
                      maxWidth: 38,
                    ),
                    child: IconButton(
                      onPressed: _newMsg.isEmpty ? null : _sendMessage,
                      icon: Icon(
                        Icons.arrow_upward_rounded,
                        weight: 6,
                      ),
                      color: HexColor('#131313'),
                    ),
                  ),
                ),
                controller: _controller,
                onEditingComplete: _newMsg.isEmpty ? null : _sendMessage,
                onChanged: (value) {
                  setState(() {
                    _newMsg = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
