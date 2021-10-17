import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/model/message.dart';
import 'package:flutter_chatify_app/services/abstract/db_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(AuthUser user) async {
    var _userToMap = user.toMap();
    await _firebaseFirestore
        .collection(("users"))
        .doc(user.userID)
        .set(_userToMap);

    // DocumentSnapshot<Map<String, dynamic>> _readUser =
    //     await _firebaseFirestore.doc("users/${user.userID}").get();
    // var getUser = AuthUser.fromMap(_readUser.data()!);
    // print("---->" + getUser.toString());
    return true;
  }

  @override
  Future<AuthUser?> readUser(String? userID) async {
    DocumentSnapshot<Map<String, dynamic>> _userRef =
        await _firebaseFirestore.doc("users/${userID}").get();
    var _readUser = _userRef.data();
    var getUser = _readUser != null ? AuthUser.fromMap(_readUser) : null;
    return getUser;
  }

  Future<bool> _checkUserName(String newUserName) async {
    var users = await _firebaseFirestore
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .get();

    return users.docs.length > 0;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    return await _checkUserName(newUserName)
        ? throw (" kullanıcı adı kullanılmakta")
        : await _firebaseFirestore
            .collection("users")
            .doc(userID)
            .update({"userName": newUserName}).then((value) => true);
  }

  @override
  Future<bool> updateProfilUrl(String userID, String profilPhotoURL) async {
    return await _firebaseFirestore
        .collection("users")
        .doc(userID)
        .update({"profilURL": profilPhotoURL}).then((value) => true);
  }

  @override
  Future<List<AuthUser>> getUserwithPagination(
      AuthUser? lastBroughtUser, int numberOfUserToFetch) async {
    QuerySnapshot _querySnapshot;
    List<AuthUser> _allUsers = [];

    if (lastBroughtUser == null) {
      _querySnapshot = await _firebaseFirestore
          .collection("users")
          .orderBy("userName")
          .limit(numberOfUserToFetch)
          .get();
    } else {
      _querySnapshot = await _firebaseFirestore
          .collection("users")
          .orderBy("userName")
          .startAfter([lastBroughtUser.userName])
          .limit(numberOfUserToFetch)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      AuthUser _tekUser = AuthUser.fromMap(snap.data() as Map<String, dynamic>);
      _allUsers.add(_tekUser);
    }

    return _allUsers;
  }

  @override
  Future<List<Message>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("messages")
        .where("fromMe", isEqualTo: userID)
        .orderBy("createDate", descending: true)
        .get();

    List<Message> allMessages = [];

    for (DocumentSnapshot singleMessage in querySnapshot.docs) {
      Message _singleKonusma =
          Message.fromMap(singleMessage.data as Map<String, dynamic>);
      /*print("okunan konusma tarisi:" +
          _tekKonusma.olusturulma_tarihi.toDate().toString());*/
      allMessages.add(_singleKonusma);
    }

    return allMessages;
  }

  @override
  Stream<List<Message>> getMessages(
      String currentUserID, String chattedUserId) {
    var snapShot = _firebaseFirestore
        .collection("chats")
        .doc(currentUserID + "--" + chattedUserId)
        .collection("messages")
        .where("fromMe", isEqualTo: currentUserID)
        .orderBy("createDate", descending: true)
        .limit(1)
        .snapshots();
    return snapShot.map((messageList) => messageList.docs
        .map((message) => Message.fromMap(message.data()))
        .toList());
  }

  @override
  Future<List<Message>> getMessagewithPagination(
      String currentUserID,
      String chattedUserId,
      Message? lastReceivedMessage,
      int pageViewSendNumber) async {
    QuerySnapshot _querySnapshot;
    List<Message> _allMessages = [];

    if (lastReceivedMessage == null) {
      _querySnapshot = await _firebaseFirestore
          .collection("messages")
          .doc(currentUserID + "--" + chattedUserId)
          .collection("messages")
          .where("fromMe", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .limit(pageViewSendNumber)
          .get();
    } else {
      _querySnapshot = await _firebaseFirestore
          .collection("messages")
          .doc(currentUserID + "--" + chattedUserId)
          .collection("messages")
          .where("currentUserID", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .startAfter([lastReceivedMessage.date])
          .limit(pageViewSendNumber)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Message _singleMessage =
          Message.fromMap(snap.data as Map<String, dynamic>);
      _allMessages.add(_singleMessage);
    }

    return _allMessages;
  }

  @override
  Future<bool> saveMessage(Message messageToBeAdded) async {
    var _messagesID = _firebaseFirestore.collection("chats").doc().id;
    var _myDocumentID =
        messageToBeAdded.fromWho + "--" + messageToBeAdded.toWho;
    var _receiverDocumentID =
        messageToBeAdded.toWho + "--" + messageToBeAdded.fromWho;

    var _messageToBeAddedMap = messageToBeAdded.toMap();

    await _firebaseFirestore
        .collection("chats")
        .doc(_myDocumentID)
        .collection("messages")
        .doc(_messagesID)
        .set(_messageToBeAddedMap);

    await _firebaseFirestore.collection("messages").doc(_myDocumentID).set({
      "fromWho": messageToBeAdded.fromWho,
      "toWho": messageToBeAdded.toWho,
      "messages": messageToBeAdded.messages,
      "konusma_goruldu": false,
      "date": FieldValue.serverTimestamp(),
    });

    _messageToBeAddedMap.update("fromMe", (deger) => false);
    _messageToBeAddedMap.update(
        "messageSender", (deger) => messageToBeAdded.toWho);

    await _firebaseFirestore
        .collection("messages")
        .doc(_receiverDocumentID)
        .collection("messages")
        .doc(_messagesID)
        .set(_messageToBeAddedMap);

    await _firebaseFirestore
        .collection("messages")
        .doc(_receiverDocumentID)
        .set({
      "toWho": messageToBeAdded.toWho,
      "fromWho": messageToBeAdded.fromWho,
      "son_yollanan_messages": messageToBeAdded.messages,
      "konusma_goruldu": false,
      "date": FieldValue.serverTimestamp(),
    });

    return true;
  }
}
