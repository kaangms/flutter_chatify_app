import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/locator.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/model/message.dart';
import 'package:flutter_chatify_app/repository/user_repository.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  List<Message>? _allMessage;
  ChatViewState _state = ChatViewState.Idle;
  static final pageViewSendNumber = 10;
  UserRepository _userRepository = locator<UserRepository>();
  final AuthUser currentUser;
  final AuthUser chattedUser;
  Message? _lastReceivedMessage;
  Message? _listAddedFirstMessage;
  bool _hasMore = true;
  bool _newMessageListener = false;

  bool get hasMoreLoading => _hasMore;

  StreamSubscription? _streamSubscription;

  ChatViewModel({required this.currentUser, required this.chattedUser}) {
    _allMessage = [];
    getMessageWithPagination(false);
  }

  List<Message>? get allMessage => _allMessage;

  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  dispose() {
    print("Chatviewmodel dispose edildi");
    _streamSubscription!.cancel();
    super.dispose();
  }

  Future<bool> saveMessage(
      Message saveMessage, AuthUser currentUser) async {
    return await _userRepository.saveMessage(saveMessage, currentUser);
  }

  void getMessageWithPagination(bool bringingNewMessage) async {
    if (_allMessage!.length > 0) {
      _lastReceivedMessage = _allMessage!.last;
    }

    if (!bringingNewMessage) state = ChatViewState.Busy;

    var messagesBrought = await _userRepository.getMessageWithPagination(
        currentUser.userID!,
        chattedUser.userID!,
        _lastReceivedMessage!,
        pageViewSendNumber);

    if (messagesBrought.length < pageViewSendNumber) {
      _hasMore = false;
    }

    /*getirilenMesajlar
        .forEach((msj) => print("getirilen mesajlar:" + msj.mesaj));*/

    _allMessage!.addAll(messagesBrought);
    if (_allMessage!.length > 0) {
      _listAddedFirstMessage = _allMessage!.first;
      // print("Listeye eklenen ilk mesaj :" + _listeyeEklenenIlkMesaj.mesaj);
    }

    state = ChatViewState.Loaded;

    if (_newMessageListener == false) {
      _newMessageListener = true;
      //print("Listener yok o yüzden atanacak");
      assignToNewMessageList();
    }
  }

  Future<void> getMoreMessage() async {
    //print("Daha fazla mesaj getir tetiklendi - viewmodeldeyiz -");
    if (_hasMore) getMessageWithPagination(true);
    /*else
      print("Daha fazla eleman yok o yüzden çagrılmayacak");*/
    await Future.delayed(Duration(seconds: 2));
  }

  void assignToNewMessageList() {
    //print("Yeni mesajlar için listener atandı");
    _streamSubscription = _userRepository
        .getMessages(currentUser.userID!, chattedUser.userID!)
        .listen((anlikData) {
      if (anlikData.isNotEmpty) {
        //print("listener tetiklendi ve son getirilen veri:" +anlikData[0].toString());

        if (anlikData[0].date != null) {
          if (_listAddedFirstMessage == null) {
            _allMessage!.insert(0, anlikData[0]);
          } else if (_listAddedFirstMessage!.date!.millisecondsSinceEpoch !=
              anlikData[0].date!.millisecondsSinceEpoch)
            _allMessage!.insert(0, anlikData[0]);
        }

        state = ChatViewState.Loaded;
      }
    });
  }
}
