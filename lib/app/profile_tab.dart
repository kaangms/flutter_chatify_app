import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/view_model/user_model.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          TextButton(
            onPressed: () {
              _logOut(context);
            },
            child: Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            // style: TextButton.styleFrom(primary: Colors.white),
          )
        ],
      ),
      body: Center(
        child: Text("Profil Sayfası"),
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
}
