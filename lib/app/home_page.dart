import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/app/my_custom_botton_navi.dart';
import 'package:flutter_chatify_app/app/profile_tab.dart';
import 'package:flutter_chatify_app/app/tab_items.dart';
import 'package:flutter_chatify_app/app/users_tab.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';

class HomePage extends StatefulWidget {
  HomePage({
    required this.user,
    Key? key,
  }) : super(key: key);
  final AuthUser user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Users;
  Map<TabItem, Widget> allPages() {
    return {TabItem.Users: UsersTab(), TabItem.Profile: ProfileTab()};
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKey = {
    TabItem.Users: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>()
  };

  @override
  Widget build(BuildContext context) {
    // navigatorKey[_currentTab]!.currentState == null
    //     ? true
    //     : navigatorKey[_currentTab]!
    //         .currentState!
    //         .maybePop()
    //         .then((result) => debugPrint(result.toString()));
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKey[_currentTab]!.currentState!.maybePop(),
      child: MyCustomBottomNavigation(
          createNavigatorKey: navigatorKey,
          createTabPage: allPages(),
          currentTab: _currentTab,
          onselectedTab: (selectedTab) {
            //debugPrint("Seçilen tab item" + selectedTab.toString());

            if (selectedTab == _currentTab) {
              navigatorKey[selectedTab]!
                  .currentState!
                  .popUntil((route) => route.isFirst);
            } else
              setState(() {
                _currentTab = selectedTab;
              });
          }),
    );

    //  Scaffold(
    //     appBar: AppBar(
    //       title: Text("AnaSayfa"),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             _logOut(context);
    //           },
    //           child: Text(
    //             "Çıkış Yap",
    //             style: TextStyle(color: Colors.white),
    //           ),
    //           // style: TextButton.styleFrom(primary: Colors.white),
    //         )
    //       ],
    //     ),
    //     body: MyCustomBottomNavigation(
    //         createTabPage: allPages(),
    //         currentTab: _currentTab,
    //         onselectedTab: (selectedTab) {
    //           //debugPrint("Seçilen tab item" + selectedTab.toString());
    //           setState(() {
    //             _currentTab = selectedTab;
    //           });
    //         }));
  }

  // Future<bool> _logOut(BuildContext context) async {
  //   final _usermodel = Provider.of<UserModel>(context, listen: false);
  //   var result = _usermodel.signOut();
  //   debugPrint("_logoutstatus.toString" +
  //       result.toString() +
  //       "/n" +
  //       _usermodel.toString());
  //   return result;
  // }
}
