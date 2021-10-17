class MessageModel {
  String? fromId;
  String? messageContent;
  int? sentTime;
  String? messageType;

  MessageModel({
    required this.fromId,
    required this.messageContent,
    required this.messageType,
    required this.sentTime,
  });
}
