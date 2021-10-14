import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chatify_app/app/tab_items.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  const MyCustomBottomNavigation({
    Key? key,
    required this.currentTab,
    required this.onselectedTab,
    required this.createTabPage,
    required this.createNavigatorKey,
  }) : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onselectedTab;
  final Map<TabItem, Widget> createTabPage;
  final Map<TabItem, GlobalKey<NavigatorState>> createNavigatorKey;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _bottomNavigationBarItem(TabItem.Users),
            _bottomNavigationBarItem(TabItem.Profile),
          ],
          onTap: (index) => onselectedTab(TabItem.values[index]),
        ),
        tabBuilder: (context, index) {
          final showItem = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: createNavigatorKey[showItem],
            builder: (context) => createTabPage[showItem]!,
          );
        });
  }

  BottomNavigationBarItem _bottomNavigationBarItem(TabItem tabItem) {
    final createTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
        icon: Icon(createTab!.icon), label: createTab.label);
  }
}
