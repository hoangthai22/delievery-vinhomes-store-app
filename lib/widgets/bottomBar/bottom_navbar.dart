import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';

enum TabItem { home, product, menu, transaction, account }

const Map<TabItem, String> tabName = {
  TabItem.home: 'Đơn hàng',
  TabItem.product: 'Sản phẩm',
  TabItem.menu: 'Thực đơn',
  TabItem.transaction: 'Lịch sử',
  TabItem.account: 'Tài khoản',
};

const Map<TabItem, IconData> tabIcon = {
  TabItem.home: Icons.shopping_bag_outlined,
  TabItem.product: Icons.fastfood,
  TabItem.menu: Icons.list_alt_sharp,
  TabItem.transaction: Icons.history,
  TabItem.account: Icons.account_circle,
};

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
  late final TabItem currentTab;
  late final ValueChanged<TabItem> onSelectTab;

  BottomNavbar({required this.currentTab, required this.onSelectTab});
}

class _BottomNavbarState extends State<BottomNavbar> {
  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: Icon(tabIcon[tabItem]),
      label: tabName[tabItem],
    );
  }

  BottomNavigationBarItem _buildNofication(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: Icon(tabIcon[tabItem]),
      label: tabName[tabItem],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(color: MaterialColors.primary),
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentTab.index,
      selectedItemColor: MaterialColors.primary,
      items: [
        _buildItem(TabItem.home),
        _buildNofication(TabItem.product),
        _buildItem(TabItem.menu),
        _buildNofication(TabItem.transaction),
        _buildItem(TabItem.account),
      ],
      onTap: (index) => widget.onSelectTab(
        TabItem.values[index],
      ),
    );
  }
}
