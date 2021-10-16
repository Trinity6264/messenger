class MessageModel {
  String? fromId;
  String? toId;
  String? messageContent;
  int? sentTime;
  String? messageType;

  MessageModel({
    required this.fromId,
    required this.toId,
    required this.messageContent,
    required this.messageType,
    required this.sentTime,
  });
}
