import 'dart:io';

import 'package:flutter_chatify_app/services/abstract/storage_base.dart';

class FakeStorageService implements StorageBase {
  @override
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekDosya) {
    // ignore: todo
    // TODO: implement uploadFile
    throw UnimplementedError();
  }
}
