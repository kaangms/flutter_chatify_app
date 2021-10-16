import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/common/widget/platform_sensitive_alert_dialog.dart';
import 'package:flutter_chatify_app/common/widget/social_log_in_button.dart';
import 'package:flutter_chatify_app/view_model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  TextEditingController? _textEditingControllerUsername;
  final ImagePicker _picker = ImagePicker();
  ImageProvider? _image;

  @override
  void initState() {
    _textEditingControllerUsername = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingControllerUsername != null
        ? _textEditingControllerUsername!.dispose()
        : false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    debugPrint(_userModel.user.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          TextButton(
            onPressed: () {
              _aproveWantForExit(context);
            },
            child: Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            // style: TextButton.styleFrom(primary: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan Çek"),
                                  onTap: () {
                                    _takeAPhoto(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden Seç"),
                                  onTap: () {
                                    _selectFromGallery(context);
                                  },
                                )
                              ],
                            ),
                          );
                        }).whenComplete(() => null);
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        _image ?? NetworkImage(_userModel.user!.profilURL!),
                    radius: 75,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user!.email!,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _textEditingControllerUsername,
                  // initialValue: _userModel.user!.email!,
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    hintText: "Kullanıcı Adınız..",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: SocialLogInButton(
                    buttonText: "Değişiklikleri Kaydet",
                    butonIcon: Icon(Icons.one_k_sharp),
                    onPressed: () {
                      _userNameUpdate(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _logOut(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    var result = _usermodel.signOut();
    debugPrint("_logoutstatus.toString" +
        result.toString() +
        "/n" +
        _usermodel.toString());
    return result;
  }

  Future _aproveWantForExit(BuildContext context) async {
    final sonuc = await PlatformSensitiveAlertDialog(
      header: "Emin Misiniz?",
      content: "Çıkmak istediğinizden emin misiniz?",
      baseButtonText: "Evet",
      cancelButtonText: "Vazgeç",
    ).show(context);

    if (sonuc == true) {
      _logOut(context);
    }
  }

  void _userNameUpdate(BuildContext context) async {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    var _newUserName = _textEditingControllerUsername!.text;
    var currentUser = _userModel.user!;
    // debugPrint(
    //     (_newUserName.toString() == currentUserName.toString()).toString());
    _newUserName != currentUser.userName!
        ? await checkupdateUserName(currentUser.userID!, _newUserName)
        : PlatformSensitiveAlertDialog(
                header: "Hata",
                content: "Kullanıcı Değişikliği yapmadınız",
                baseButtonText: "Tamam")
            .show(context);
  }

  checkupdateUserName(String userID, String newUserName) async {
    try {
      UserModel _userModel = Provider.of<UserModel>(context, listen: false);
      await _userModel.updateUserName(userID, newUserName);
    } catch (e) {
      PlatformSensitiveAlertDialog(
              header: "Hata",
              content: newUserName + " " + e.toString(),
              baseButtonText: "Tamam")
          .show(context);
    }
  }

  void _takeAPhoto(BuildContext context) async {
    final XFile? newImageFile =
        await _picker.pickImage(source: ImageSource.camera);
    File file = File(newImageFile!.path);
    _uploadProfilUrl(context, file);
    setState(() {
      _image = FileImage(file);
    });
  }

  void _selectFromGallery(BuildContext context) async {
    final XFile? newImageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    File file = File(newImageFile!.path);
    _uploadProfilUrl(context, file);
    setState(() {
      _image = FileImage(file);
    });
  }

  void _uploadProfilUrl(BuildContext context, File uploadFile) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    await _usermodel.uploadFile(_usermodel.user!.userID!, 'Image', uploadFile);
  }
}
