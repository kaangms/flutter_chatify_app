import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthUser {
  String? userID;
  String? email;
  String? userName;
  String? profilURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? seviye;
  AuthUser({
    this.userID,
    this.email,
    this.userName,
    this.profilURL,
    this.createdAt,
    this.updatedAt,
    this.seviye,
  });

  Map<String, dynamic> toMap() {
    print(userName);
    print("-----------------------------------------")
    print(email!.split("@")[0] + randomGetNumber());
    return {
      'userID': userID,
      'email': email,
      'userName': userName ?? email!.split("@")[0] + randomGetNumber(),
      // email!.substring(0, email!.indexOf('@')) + randomSayiUret(),
      'profilURL': profilURL ??
          'https://avatars.githubusercontent.com/u/54083292?s=400&u=972ca8ada1960eb380fbbbcf93d4c85e46017378&v=4.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  AuthUser.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'];

  AuthUser.idAndPhotoUrl({required this.userID, required this.profilURL});

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $seviye}';
  }

  String randomGetNumber() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
