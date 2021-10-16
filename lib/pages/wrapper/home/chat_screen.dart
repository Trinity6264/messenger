import 'package:flutter/material.dart';
import 'package:messenger/const/const_color.dart';
import 'package:messenger/models/meassge_model.dart';
import 'package:messenger/models/store_model.dart';
import 'package:messenger/pages/wrapper/home/messgae_widget.dart';
import 'package:messenger/service/custom_firestore.dart';
import 'package:messenger/shared/message_dec.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.storeModel, required this.chatId})
      : super(key: key);
  final StoreModel storeModel;
  final String chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    _textEditingController.addListener;
    loadLocal();
  }

  String id = '';
  String name = '';
  String email = '';
  String message = '';
  String messageType = '';

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  static final _store = CustomFirestore.instance;
  final ScrollController _listScrollController = ScrollController();

  Future<void> loadLocal() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString('uid') ?? 'no uid';
    name = _prefs.getString('name') ?? 'no name';
    email = _prefs.getString('email') ?? 'no email';
    // getChatId();
  }

  // getChatId() {
  //   if (id.hashCode < widget.storeModel.uid.hashCode) {
  //     chatId = '${id}_${widget.storeModel.uid}';
  //   } else {
  //     chatId = '${widget.storeModel.uid}_$id';
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      appBar: AppBar(
        title: Text(
          widget.storeModel.name.toString(),
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          _listOfChats(context),
          _inputField(),
        ],
      ),
    );
  }

  // List of chats

  Widget _listOfChats(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: _store.getMessages(widget.chatId),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No message Found'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            shrinkWrap: true,
            controller: _listScrollController,
            reverse: true,
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final message = snapshot.data![index];
              return MessageWidget(
                  message: message, isMe: message.fromId == id);
            },
          );
        }
      },
    );
  }

  // text field and input
  Widget _inputField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.black,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                focusNode: _focusNode,
                onChanged: (val) {
                  message = val;
                },
                controller: _textEditingController,
                decoration: textDecoration.copyWith(
                  prefixIcon: const Icon(Icons.emoji_emotions),
                  hintText: 'Enter message',
                ),
              ),
            ),
            IconButton(
              color: bgColor,
              onPressed: () {
                if (message != '') {
                  _textEditingController.clear();
                  _store.sendMessage(
                    chatId: widget.chatId,
                    fromId: id,
                    toId: widget.storeModel.uid.toString(),
                    message: message,
                    messageType: 'text',
                  );
                  _listScrollController.animateTo(
                    0.5,
                    duration: const Duration(microseconds: 500),
                    curve: Curves.easeOut,
                  );
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
