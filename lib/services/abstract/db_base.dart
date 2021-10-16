import 'package:flutter_chatify_app/model/auth_user.dart';
// import 'package:flutter_lovers/model/konusma.dart';
// import 'package:flutter_lovers/model/mesaj.dart';
// import 'package:flutter_lovers/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(AuthUser user);
  Future<AuthUser?> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateProfilUrl(String userID, String profilPhotoURL);
  // Future<List<User>> getUserwithPagination(
  //     User enSonGetirilenUser, int getirilecekElemanSayisi);
  // Future<List<Konusma>> getAllConversations(String userID);
  // Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  // Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
  // Future<DateTime> saatiGoster(String userID);
}
