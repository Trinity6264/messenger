import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/models/meassge_model.dart';
import 'package:messenger/models/store_model.dart';
import 'package:messenger/utils/transform_chat.dart';

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

  // sending chat message to firestore
  Future sendMessage({
    required String chatId,
    required String fromId,
    required String messageContent,
    required String messageType,
    required MessageModel? reply,
  }) async {
    final refMessage = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection(chatId)
        .doc(DateTime.now().microsecondsSinceEpoch.toString());
    final _modelMess = MessageModel(
      fromId: fromId,
      messageContent: messageContent,
      messageType: messageType,
      sentTime: DateTime.now(),
      replyMessage: reply,
    );
    await refMessage.set(_modelMess.toJson());
  }

//  getting chat message
  Stream<List<MessageModel>> getMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection(chatId)
        .orderBy('sentTime', descending: true)
        .snapshots()
        .transform(TransformerChat.transformer(MessageModel.fromJson));
  }

// generaing chat room Id,
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

  // Delete data
  Future deleteData(int index, String chatId) async {
    try {
      final CollectionReference _ref = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection(chatId);
      QuerySnapshot snapshot = await _ref.get();
      snapshot.docs[index].reference.delete();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
