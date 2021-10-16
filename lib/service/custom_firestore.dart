import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/models/meassge_model.dart';
import 'package:messenger/models/store_model.dart';

class CustomFirestore {
  CustomFirestore._();
  static final instance = CustomFirestore._();
  // Registering user credential
  Future credentialToFirestore(
      String uid, Map<String, dynamic> userInfo) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .set(userInfo);
  }

  // get all users from fire store
  List<StoreModel> _fetchUsers(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((data) {
      return StoreModel(
        uid: data['userId'],
        name: data['name'],
        email: data['email'],
      );
    }).toList();
  }

  Stream<List<StoreModel>> get getData {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map(_fetchUsers);
  }

  Future sendMessage({
    required String chatId,
    required String fromId,
    required String toId,
    required String message,
    required String messageType,
  }) async {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection(chatId)
        .doc(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      'fromId': fromId,
      'toId': toId,
      'messageContent': message,
      'sentAt': DateTime.now().microsecondsSinceEpoch,
      'type': messageType,
    });
  }

  // get all users from fire store
  List<MessageModel> _fetchMessage(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((data) {
      return MessageModel(
        fromId: data['fromId'],
        toId: data['toId'],
        messageContent: data['messageContent'],
        messageType: data['type'],
        sentTime: data['sentAt'],
      );
    }).toList();
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection(chatId)
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map(_fetchMessage);
  }

// create chat room Id
  Future chatRoomId({
    required String chatId,
    required Map<String, dynamic> infoData,
  }) async {
    var _doc = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final snapshot =
        await FirebaseFirestore.instance.runTransaction((transaction) {
      return transaction.get(_doc);
    });
    if (snapshot.exists) {
      return;
    } else {
      _doc.set(infoData);
    }
  }
}
