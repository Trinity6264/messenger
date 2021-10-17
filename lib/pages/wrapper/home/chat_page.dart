import 'package:flutter/material.dart';
import 'package:messenger/models/store_model.dart';
import 'package:messenger/pages/wrapper/home/widgets/message_widget.dart';
import 'package:messenger/pages/wrapper/home/widgets/new_message.dart';
import 'package:messenger/pages/wrapper/home/widgets/profile_widget.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final StoreModel user;

  const ChatPage({
    required this.user,
    required this.chatId,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: user.name.toString()),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(chatRoomId: chatId),
                ),
              ),
              NewMessageWidget(chatId: chatId)
            ],
          ),
        ),
      );
}
