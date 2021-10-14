
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/app/sign_in/log_in_with_email_and_password_page.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/view_model/user_model.dart';
import 'package:provider/provider.dart';
import '../../common/widget/social_log_in_button.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatify'),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Oturum Aç",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SocialLogInButton(
                buttonText: 'Google ile Giriş',
                buttonColor: Colors.white,
                textColor: Colors.black,
                butonIcon: Image.asset("images/google-logo.png"),
                onPressed: () => _signInWithGoogle(context)),
            SocialLogInButton(
                buttonText: "Facebook ile Giriş Yap",
                buttonColor: Color(0xFF334D92),
                butonIcon: Image.asset("images/facebook-logo.png"),
                onPressed: () => _signInWithFacebook(context)),
            SocialLogInButton(
                buttonText: "Email ve Şifre ile Giriş Yap",
                buttonColor: Color(0xFF008AA9),
                butonIcon: Icon(Icons.email),
                onPressed: () => _signInWithEmailandPassword(context)),
            SocialLogInButton(
                buttonText: "Misafir Girişi",
                buttonColor: Color(0xFFFF7F00),
                butonIcon: Icon(Icons.supervised_user_circle),
                onPressed: () => _anonymousLogIn(context)),
          ],
        ),
      ),
    );
  }

  void _signInWithEmailandPassword(BuildContext context) async {
    Navigator.of(context).push(CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (context) => LogInWithEmailAndPassword(),
    ));
  }

  void _anonymousLogIn(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    AuthUser? _user = await _userModel.singInAnonymously();
    if (_user != null) {
      debugPrint(
          "Oturum açan user id:" + (_user.userID ?? "oturum mevcut değil"));
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    AuthUser? _user = await _userModel.signInWithGoogle();

    if (_user != null) {
      debugPrint("Oturum açan user id:" + (_user.toString()));
    }
  }

  void _signInWithFacebook(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    AuthUser? _user = await _userModel.signInWithFacebook();
    if (_user != null) {
      debugPrint("Oturum açan user id:" + (_user.toString()));
    }
  }
  // void _anonymousLogIn() async {
  //   bool _networkStatus = false;

  //   ///------------------------
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     // I am connected to a mobile network.
  //     debugPrint("I am connected to a mobile network.");
  //     _networkStatus = true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     // I am connected to a wifi network.
  //     debugPrint("I am connected to a wifi network.");
  //     _networkStatus = true;
  //   } else {
  //     _networkStatus = false;
  //   }

  //   ///------------------------
  //   if (_networkStatus) {
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //     UserCredential resultUserCredential = await auth.signInAnonymously();
  //     print(resultUserCredential.user!.uid);
  //   } else {
  //     debugPrint("no internet");
  //   }
  // }
}
