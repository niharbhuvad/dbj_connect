import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatid;
  List<MsgModel> msgs = [];

  ChatModel({required this.chatid});
}

class MsgModel {
  final String from;
  final String msg;
  final Timestamp timestamp;

  MsgModel({required this.from, required this.msg, required this.timestamp});
}
