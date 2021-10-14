import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Users, Profile }

class TabItemData {
  final String label;
  final IconData icon;

  TabItemData(this.label, this.icon);
  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users: TabItemData("Users", Icons.supervised_user_circle),
    TabItem.Profile: TabItemData("Profil", Icons.person)
  };
}
