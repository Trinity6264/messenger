import 'package:messenger/utils/transform_chat.dart';

class MessageModel {
  String? fromId;
  String? messageContent;
  MessageModel? replyMessage;
  DateTime? sentTime;
  String? messageType;

  MessageModel({
    required this.fromId,
    required this.messageContent,
    required this.messageType,
    required this.sentTime,
    required this.replyMessage,
  });

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
        fromId: json['fromId'],
        messageContent: json['messageContent'],
        messageType: json['messageType'],
        sentTime: TransformerChat.toDateTime(json['sentTime']),
        replyMessage:
            json['reply'] == null ? null : MessageModel.fromJson(json['reply']),
      );

  Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'messageContent': messageContent,
        'messageType': messageType,
        'sentTime': TransformerChat.fromDateTimeToJson(sentTime),
        'reply': replyMessage == null ? null : replyMessage!.toJson(),
      };
}
