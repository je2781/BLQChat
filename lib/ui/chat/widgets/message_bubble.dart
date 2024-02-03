import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MessageBubble extends StatelessWidget {
  final String msg;
  final bool isMe;
  final String userImage;
  final String username;

  const MessageBubble(this.msg, this.isMe, this.username, this.userImage,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.secondary
                    : HexColor('#1a1a1a'),
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                  topLeft: !isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(2),
                  topRight: isMe
                      ? const Radius.circular(2)
                      : const Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  Text(
                    msg,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? 175 : 125,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
