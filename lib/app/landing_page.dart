import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/app/home_page.dart';
import 'package:flutter_chatify_app/app/sign_in/sign_in_page.dart';
import 'package:flutter_chatify_app/view_model/user_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: true);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user != null)
        return HomePage(
          user: _userModel.user!,
        );
      else
        return SignInPage();
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
