import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/models/meassge_model.dart';
import 'package:messenger/pages/wrapper/home/widgets/reply_widget.dart';
import 'package:messenger/service/custom_firestore.dart';

class InputText extends StatefulWidget {
  final String chatId;
  final FocusNode focus;
  final MessageModel? replyMessage;
  final VoidCallback callback;
  final String? name;

  const InputText({
    required this.chatId,
    required this.focus,
    required this.name,
    required this.callback,
    required this.replyMessage,
    Key? key,
  }) : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final _controller = TextEditingController();
  String message = '';

  static const _inputTop = Radius.circular(12);
  static const _inputBottom = Radius.circular(24);

  void sendMessage() async {
    _controller.clear();
    widget.callback();
    FocusScope.of(context).unfocus();
    await CustomFirestore.instance.sendMessage(
      chatId: widget.chatId,
      fromId: FirebaseAuth.instance.currentUser!.uid,
      messageContent: message,
      messageType: 'text',
      reply: widget.replyMessage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = widget.replyMessage != null;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg.jpg'), fit: BoxFit.cover)),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                if (isReplying) buildReply(),
                TextField(
                  focusNode: widget.focus,
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Type your message',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: isReplying ? Radius.zero : _inputBottom,
                        topRight: isReplying ? Radius.zero : _inputBottom,
                        bottomLeft: _inputBottom,
                        bottomRight: _inputBottom,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    message = value;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: message.trim().isEmpty ? null : sendMessage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReply() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: _inputTop,
          topRight: _inputTop,
        ),
      ),
      child: ReplyMessage(
        message: widget.replyMessage,
        onCancel: widget.callback,
        name: widget.name.toString(),
      ),
    );
  }
}
