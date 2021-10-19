import 'package:flutter/material.dart';
import 'package:messenger/models/store_model.dart';
import 'package:messenger/pages/wrapper/home/widgets/message_widget.dart';
import 'package:messenger/pages/wrapper/home/widgets/profile_widget.dart';
import 'package:messenger/pages/wrapper/home/widgets/text_field.dart';
import 'package:messenger/utils/auth_setting.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final StoreModel user;

  const ChatPage({
    required this.user,
    required this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final fn = FocusNode();
  @override
  Widget build(BuildContext context) {
    print('object');
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeaderWidget(name: widget.user.name.toString()),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage('images/bg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black, BlendMode.difference),
                  ),
                ),
                child: Consumer<Authsettings>(
                  builder: (_, data, __) {
                    return MessagesWidget(
                      chatRoomId: widget.chatId,
                      userName: widget.user.name.toString(),
                      onSwipeMessage: (message) {
                        data.toSwipe(message);
                        fn.requestFocus();
                      },
                    );
                  },
                ),
              ),
            ),
            Consumer<Authsettings>(
              builder: (_, data, __) {
                return InputText(
                  chatId: widget.chatId,
                  focus: fn,
                  name: widget.user.name,
                  replyMessage: data.isSwipe,
                  callback: data.toCancelSwipe,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
