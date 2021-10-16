import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chatify_app/services/abstract/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference? _storageReference;

  @override
  Future<String> uploadFile(
      String userID, String fileType, File uploadFile) async {
    _storageReference = _firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child("profil_foto.png");
    UploadTask uploadTask = _storageReference!.putFile(uploadFile);

    var url = await (await uploadTask).ref.getDownloadURL();

    return url;
  }
}
