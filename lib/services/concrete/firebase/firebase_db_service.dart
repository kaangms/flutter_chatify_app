import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
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

    DocumentSnapshot<Map<String, dynamic>> _readUser =
        await FirebaseFirestore.instance.doc("users/${user.userID}").get();
    var getUser = AuthUser.fromMap(_readUser.data()!);
    print("---->" + getUser.toString());
    return true;
  }
}
