import 'package:flutter/material.dart';
import 'package:messenger/models/meassge_model.dart';
import 'package:messenger/pages/wrapper/home/widgets/reply_widget.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final String name;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    const radius = Radius.circular(12);
    const borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
            child: Text(name.substring(0, 1)),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: _size.width * 3 / 5),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: isMe
                ? borderRadius
                    .subtract(const BorderRadius.only(bottomRight: radius))
                : borderRadius
                    .subtract(const BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() {
    final userText = Text(
      message.messageContent.toString(),
      style: const TextStyle(color: Colors.black),
      textAlign: isMe ? TextAlign.end : TextAlign.start,
    );
    if (message.replyMessage == null) {
      return userText;
    } else {
      return Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          buildIfReply(),
          userText,
        ],
      );
    }
  }

  Widget buildIfReply() {
    final replyMessage = message.replyMessage;
    final isReplying = replyMessage != null;
    return isReplying
        ? Container(
            color: Colors.grey.shade300,
            margin: const EdgeInsets.only(bottom: 8),
            child: ReplyMessage(message: replyMessage, name: name),
          )
        : Container();
  }
}
