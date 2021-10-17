import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String fromWho;
  final String toWho;
  final bool fromMe;
  final String messages;
  final String messageSender;
  late DateTime? date;
  Message({
    required this.fromWho,
    required this.toWho,
    required this.fromMe,
    required this.messages,
    required this.messageSender,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho,
      'toWho': toWho,
      'fromMe': fromMe,
      'messages': messages,
      'messageSender': messageSender,
      'date': FieldValue.serverTimestamp(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        fromWho: map['fromWho'],
        toWho: map['toWho'],
        fromMe: map['fromMe'],
        messages: map['messages'],
        messageSender: map['messageSender'],
        date: (map['date'] as Timestamp).toDate());
  }
}
