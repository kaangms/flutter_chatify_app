import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/model/message.dart';
import 'package:flutter_chatify_app/view_model/chat_view_model.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  _buildMessageList(),
                  _buildEnterNewMessage(),
                ],
              ),
            ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<ChatViewModel>(builder: (context, chatModel, child) {
      return Expanded(
        child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemBuilder: (context, index) {
            if (chatModel.hasMoreLoading &&
                chatModel.allMessage!.length == index) {
              return _newElementProgressIndicator();
            } else
              return _createChatBubble(chatModel.allMessage![index]);
          },
          itemCount: chatModel.hasMoreLoading
              ? chatModel.allMessage!.length + 1
              : chatModel.allMessage!.length,
        ),
      );
    });
  }

  Widget _buildEnterNewMessage() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Mesajınızı Yazın",
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.navigation,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_messageController.text.trim().length > 0) {
                  Message _saveMessage = Message(
                    fromWho: _chatModel.currentUser.userID!,
                    toWho: _chatModel.chattedUser.userID!,
                    fromMe: true,
                    messageSender: _chatModel.currentUser.userID!,
                    messages: _messageController.text,
                  );

                  var sonuc = await _chatModel.saveMessage(
                      _saveMessage, _chatModel.currentUser);
                  if (sonuc) {
                    _messageController.clear();
                    _scrollController.animateTo(
                      0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 10),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createChatBubble(Message snapUser) {
    Color _incomingMessageColor = Colors.blue;
    Color _sendMessageColor = Theme.of(context).primaryColor;
    final _chatModel = Provider.of<ChatViewModel>(context);
    var _clockValue = "";

    try {
      _clockValue =
          _clockValueShow(snapUser.date as Timestamp? ?? Timestamp(1, 1));
    } catch (e) {
      print("hata var:" + e.toString());
    }

    var _fromMe = snapUser.fromMe;
    if (_fromMe) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _sendMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      snapUser.messages,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_clockValue),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage:
                      NetworkImage(_chatModel.chattedUser.profilURL!),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _incomingMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(snapUser.messages),
                  ),
                ),
                Text(_clockValue),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String _clockValueShow(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getOldMessages();
    }
  }

  void getOldMessages() async {
    final _chatModel = Provider.of<ChatViewModel>(context);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatModel.getMoreMessage();
      _isLoading = false;
    }
  }

  _newElementProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
