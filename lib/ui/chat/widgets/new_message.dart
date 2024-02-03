import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

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
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: _newMsg.isEmpty ? null : _sendMessage,
            icon: const Icon(
              Icons.add,
            ),
            color: Colors.white,
          ),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                labelText: 'New message',
                contentPadding: EdgeInsets.all(6),
                suffixIcon: IconButton(
                  onPressed: _newMsg.isEmpty ? null : _sendMessage,
                  icon: const Icon(
                    Icons.arrow_upward,
                  ),
                  color: _newMsg.isEmpty
                      ? HexColor('#3a3a3a')
                      : Theme.of(context).colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HexColor('#b6b6b6'),
                  ),
                )),
            controller: _controller,
            onEditingComplete: _newMsg.isEmpty ? null : _sendMessage,
            onChanged: (value) {
              setState(() {
                _newMsg = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
