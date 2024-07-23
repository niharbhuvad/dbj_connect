import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbj_connect/model/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  const ChatPage({super.key, required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final msgCtrl = TextEditingController();
  // final scrollCtrl = ScrollController();
  ChatModel? chatModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.white,
        child: Form(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextFormField(
                  controller: msgCtrl,
                  textInputAction: TextInputAction.send,
                  onEditingComplete: sendMessage,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintText: 'Type your question...',
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  // textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: getMsgsStream(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
            // });
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              List<MsgModel> msgs = getMessageList(snapshot.data!);
              if (msgs.isEmpty) {
                return const Center(
                  child: Text("No Messages"),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                itemCount: msgs.length,
                reverse: true,
                // controller: scrollCtrl,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemBuilder: (context, index) {
                  var ts = msgs[index].timestamp.toDate();
                  var tss = "${ts.hour}:${ts.minute}";
                  return Align(
                    alignment: (msgs[index].from == widget.userId)
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            child: Text(
                              msgs[index].msg,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tss,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }),
    );
  }

  Future<void> sendMessage() async {
    try {
      if (msgCtrl.text.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(getConversationId())
            .collection("msgs")
            .add({
          "from": FirebaseAuth.instance.currentUser!.uid,
          "msg": msgCtrl.text,
          "timestamp": DateTime.now(),
        });
        msgCtrl.clear();
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMsgsStream() {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(getConversationId())
        .collection("msgs")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  List<MsgModel> getMessageList(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<MsgModel> list = [];
    for (var doc in snapshot.docs) {
      if (doc.exists) {
        var data = doc.data();
        var from = data['from'];
        var msg = data['msg'];
        var timestamp = data['timestamp'];
        list.add(MsgModel(from: from, timestamp: timestamp, msg: msg));
      }
    }
    return list;
  }

  String getConversationId() {
    var authUid = FirebaseAuth.instance.currentUser!.uid;
    return authUid.hashCode <= widget.userId.hashCode
        ? '${authUid}_${widget.userId}'
        : '${widget.userId}_$authUid';
  }
}
