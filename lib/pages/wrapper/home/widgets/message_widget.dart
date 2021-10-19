import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/models/meassge_model.dart';
import 'package:messenger/pages/wrapper/home/widgets/messages.dart';
import 'package:messenger/service/custom_firestore.dart';
import 'package:swipe_to/swipe_to.dart';

class MessagesWidget extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  final ValueChanged<MessageModel> onSwipeMessage;

  const MessagesWidget({
    required this.chatRoomId,
    required this.onSwipeMessage,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: CustomFirestore.instance.getMessages(widget.chatRoomId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return buildText('No Connection Available');
            } else {
              final messages = snapshot.data;
              return messages!.isEmpty
                  ? Container(
                      height: 100,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Card(
                        child: Center(
                          child: Text(
                            'Say HI',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, indexs) {
                        final message = messages[indexs];
                        return SwipeTo(
                          iconColor: const Color(0xffffffff),
                          onRightSwipe: () => widget.onSwipeMessage(message),
                          iconOnRightSwipe: Icons.reply,
                          iconOnLeftSwipe: Icons.delete,
                          onLeftSwipe: () {
                            return _showDeletDialog(message, indexs);
                          },
                          child: MessageWidget(
                            name: widget.userName,
                            message: message,
                            isMe: message.fromId ==
                                FirebaseAuth.instance.currentUser!.uid,
                          ),
                        );
                      },
                    );
            }
        }
      },
    );
  }

  void _showDeletDialog(MessageModel messageModel, int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Do want to delete?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                CustomFirestore.instance.deleteData(index, widget.chatRoomId);
              },
              child: const Text('Yes'),
            )
          ],
        );
      },
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
