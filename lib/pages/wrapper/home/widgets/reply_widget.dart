import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/models/meassge_model.dart';

class ReplyMessage extends StatelessWidget {
  final MessageModel? message;
  final String name;
  final VoidCallback? onCancel;
  const ReplyMessage(
      {Key? key, required this.message, this.onCancel, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 4,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(child: buildReplyMess()),
        ],
      ),
    );
  }

  Widget buildReplyMess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                message!.fromId == FirebaseAuth.instance.currentUser!.uid
                    ? 'You'
                    : name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (onCancel != null)
              GestureDetector(
                onTap: onCancel,
                child: const Icon(Icons.close, size: 16),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          message!.messageContent.toString(),
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
