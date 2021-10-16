import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:messenger/const/const_color.dart';
import 'package:messenger/models/firebase_model.dart';
import 'package:messenger/models/store_model.dart';
import 'package:messenger/pages/wrapper/home/chat_screen.dart';
import 'package:messenger/service/custom_firebase.dart';
import 'package:messenger/service/custom_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final _auth = CustomFirebase.instance;
  static final _store = CustomFirestore.instance;
  @override
  void initState() {
    super.initState();
    loadLocal();
  }

  String id = '';
  String name = '';
  String email = '';

  getChatId(String touserId, String fromuserId) {
    if (touserId.hashCode < fromuserId.hashCode) {
      return '${touserId}_$fromuserId';
    } else {
      return '${fromuserId}_$touserId';
    }
  }

  Future<void> loadLocal() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString('uid') ?? 'no uid';
    name = _prefs.getString('name') ?? 'no name';
    email = _prefs.getString('email') ?? 'no email';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            onPressed: () async {
              return await _auth.sigOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: Consumer<FirebaseModel>(
          builder: (_, data, __) {
            return Text(data.name.toString());
          },
        ),
        backgroundColor: bgColor,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: CustomFirestore.instance.getData,
        builder: (_, AsyncSnapshot<List<StoreModel>> snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: hightColor,
              direction: ShimmerDirection.ttb,
              enabled: true,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (_, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    child: const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: bgColor,
                      ),
                      title: Text('-------------'),
                      subtitle: Text('-----------'),
                    ),
                  );
                },
              ),
            );
          } else {
            return snapshot.data!.isEmpty
                ? const Center(
                    child: Text('No Users Found'),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final user = snapshot.data![index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            final chatRoomId =
                                getChatId(id, user.uid.toString());
                            Map<String, dynamic> chatInfoRoomMap = {
                              'users': [id, user.uid]
                            };
                            _store.chatRoomId(
                                chatId: chatRoomId, infoData: chatInfoRoomMap);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  storeModel: user,
                                  chatId: chatRoomId,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: bgColor,
                              child: Icon(Icons.person),
                            ),
                            title: Text(
                              user.name.toString(),
                            ),
                            subtitle: Text(
                              user.email.toString(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }
}
