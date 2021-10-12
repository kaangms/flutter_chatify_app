import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/common/widget/social_log_in_button.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/view_model/user_model.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class LogInWithEmailAndPassword extends StatefulWidget {
  LogInWithEmailAndPassword({Key? key}) : super(key: key);

  @override
  _LogInWithEmailAndPasswordState createState() =>
      _LogInWithEmailAndPasswordState();
}

class _LogInWithEmailAndPasswordState extends State<LogInWithEmailAndPassword> {
  late String _email, _password, _buttonText, _linkText;
  var _formType = FormType.LogIn;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.LogIn ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabınız Yok Mu?/Kayıt Olun"
        : "Hesabınız Var Mı?/Giriş Yap";

    final _userModel = Provider.of<UserModel>(context, listen: true);
    // if (_userModel.state == ViewState.Idle) {
    //   if (_userModel.user != null)
    //     return HomePage(
    //       user: _userModel.user,
    //     );
    // } else {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(context).pop();
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Giriş/Kayıt"),
        ),
        body: _userModel.state == ViewState.Idle
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: _userModel.errorMessageEmail == ''
                                ? null
                                : _userModel.errorMessageEmail,
                            prefixIcon: Icon(Icons.mail),
                            hintText: "Email",
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                          onSaved: (enterMail) {
                            _email = enterMail ?? '';
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              errorText: _userModel.errorMessagePassword == ''
                                  ? null
                                  : _userModel.errorMessagePassword,
                              prefixIcon: Icon(Icons.mail),
                              hintText: "Password",
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                            ),
                            onSaved: (enterPassword) {
                              _password = enterPassword ?? '';
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        SocialLogInButton(
                            buttonText: _buttonText,
                            butonIcon: Text(""),
                            radius: 20,
                            onPressed: () => _formSubmit(context)),
                        SizedBox(
                          height: 8,
                        ),
                        TextButton(
                          onPressed: () => _checkAccountStatus(),
                          child: Text(_linkText),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  _formSubmit(BuildContext context) async {
    _formKey.currentState!.save();
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_formType == FormType.LogIn) {
      AuthUser? _user =
          await _userModel.signInWithEmailandPassword(_email, _password);
      if (_user == null) {
        print("sign in olmuyor kayıt ol");
      } else {
        Navigator.pop(context);
      }

      debugPrint("Kullanıcı" + _user.toString());
    } else {
      AuthUser? _user =
          await _userModel.createUserWithEmailandPassword(_email, _password);
      debugPrint("Kullanıcı" + _user.toString());
    }
  }

  _checkAccountStatus() {
    setState(() {
      _formType == FormType.LogIn
          ? _formType = FormType.Register
          : _formType = FormType.LogIn;
    });
  }
}
