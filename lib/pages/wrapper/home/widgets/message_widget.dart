import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/models/meassge_model.dart';
import 'package:messenger/pages/wrapper/home/widgets/messages.dart';
import 'package:messenger/service/custom_firestore.dart';
import 'package:swipe_to/swipe_to.dart';

class MessagesWidget extends StatelessWidget {
  final String chatRoomId;

  const MessagesWidget({
    required this.chatRoomId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<MessageModel>>(
        stream: CustomFirestore.instance.getMessages(chatRoomId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages!.isEmpty
                    ? buildText('Say Hi..')
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return SwipeTo(
                            onRightSwipe: () {},
                            child: MessageWidget(
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

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
