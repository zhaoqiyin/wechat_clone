import 'package:flutter/material.dart';

import '../constants.dart' show Constants;

class NavigationIconView {
  final String _title;
  final IconData _icon;
  final IconData _activeIcon;
  final BottomNavigationBarItem item;

  NavigationIconView({Key key, String title, IconData icon, IconData activeIcon}) :
    _title = title,
    _icon = icon,
    _activeIcon = activeIcon,
    item = BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(activeIcon),
      title: Text(title),
      backgroundColor: Colors.white
    );
}

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NavigationIconView> _navigationViews;

  void initState() {
    super.initState();
    _navigationViews = [
      NavigationIconView(
        title: '微信',
        icon: IconData(
          0xe608,
          fontFamily: Constants.IconFontFamily,
        ),
        activeIcon: IconData(
          0xe603,
          fontFamily: Constants.IconFontFamily,
        )
      ),
      NavigationIconView(
        title: '通讯录',
        icon: IconData(
          0xe601,
          fontFamily: Constants.IconFontFamily,
        ),
        activeIcon: IconData(
          0xe656,
          fontFamily: Constants.IconFontFamily,
        )
      ),
      NavigationIconView(
        title: '发现',
        icon: IconData(
          0xe600,
          fontFamily: Constants.IconFontFamily,
        ),
        activeIcon: IconData(
          0xe671,
          fontFamily: Constants.IconFontFamily,
        )
      ),
      NavigationIconView(
        title: '我',
        icon: IconData(
          0xe607,
          fontFamily: Constants.IconFontFamily,
        ),
        activeIcon: IconData(
          0xe630,
          fontFamily: Constants.IconFontFamily,
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews.map((NavigationIconView view){
        return view.item;
      }).toList(),
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      onTap: (int index){
        print('点击的是第$index个Tab');
      },
    );
    return Scaffold(
      appBar: AppBar(
        title:Text('微信'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () { print('点击了搜索按钮'); },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () { print('显示下拉列表'); },
          )
        ],
      ),
      body: Container(
        color: Colors.pink,
      ),
      bottomNavigationBar: botNavBar,
    );
  }
}