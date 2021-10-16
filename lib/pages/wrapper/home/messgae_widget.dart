import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:messenger/models/meassge_model.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  const MessageWidget({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(message.messageContent);
    const radius = Radius.circular(15);
    const borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMe)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(13),
            constraints: const BoxConstraints(maxWidth: 140),
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[100] : Colors.greenAccent[100],
              borderRadius: isMe
                  ? borderRadius.subtract(
                      const BorderRadius.only(bottomRight: radius),
                    )
                  : borderRadius.subtract(
                      const BorderRadius.only(bottomLeft: radius),
                    ),
            ),
            child: buildMessage(),
          ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.messageContent.toString(),
            style: TextStyle(color: isMe ? Colors.black : Colors.black),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          )
        ],
      );
}
