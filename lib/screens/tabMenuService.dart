import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';

import 'package:cleanmate_customer_app/tabs/tab_menu_service/service.dart' as _firstTab;
import 'package:cleanmate_customer_app/tabs/tab_menu_service/favorite.dart' as _secondTab;
import 'package:cleanmate_customer_app/tabs/tab_menu_service/cart.dart' as _thirdTab;
import 'category.dart';
import 'package:badges/badges.dart';

class TabService extends StatefulWidget {
  @override
  _TabServiceState createState() => new _TabServiceState();
}
class _TabServiceState extends State<TabService> {
  Color cl_bar = HexColor("#18b4ed");
  Color cl_text_pro_th=HexColor("#667787");
  Color cl_text_pro_en=HexColor("#989fa7");
  PageController _tabController;

  var _title_app = null;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    this._title_app = TabItems[0].title;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void categoty() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
            backgroundColor: cl_back,
            appBar: new AppBar(
              backgroundColor: cl_bar,
              title: const Text('Category'),
            ),
            body: makeBodyCate,
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) =>
      new Scaffold(
        appBar: new AppBar(
          backgroundColor: cl_back,
          elevation: 0.0,
          centerTitle: true,
          title: new Text(
            _title_app,
            style: new TextStyle(
                color: HexColor("#667787"),
                fontSize: Theme
                    .of(context)
                    .platform == TargetPlatform.iOS ? 17.0 : 20.0,
                fontFamily: 'Poppins'
            ),
        ),
          leading: new IconButton(
            icon: new Icon(Icons.chevron_left, color: HexColor("#667787")),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
          //Content of tabs
          body: new PageView(
            controller: _tabController,
            onPageChanged: onTabChanged,
            children: <Widget>[
              new _firstTab.Service(),
              new _secondTab.Category(),
              new _thirdTab.Cart()
            ],
          ),

          //Tabs
          bottomNavigationBar: Theme
              .of(context)
              .platform == TargetPlatform.iOS ?
          new CupertinoTabBar(
            activeColor: Colors.cyan,
            inactiveColor: cl_text_pro_en,
            currentIndex: _tab,
            onTap: onTap,
            items: TabItems.map((TabItem) {
              return new BottomNavigationBarItem(
                title: new Text(TabItem.title),
                icon: new Icon(TabItem.icon),
              );
            }).toList(),
          ) :
          Container(
            //margin: EdgeInsets.only(bottom: 18.0),
              height: 65.0,
              width: double.infinity,

              child: new CupertinoTabBar(
                activeColor: Colors.cyan,
                inactiveColor: cl_text_pro_en,
                currentIndex: _tab,
                onTap: onTap,
                items: TabItems.map((TabItem) {
                  return new BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    title: new Text(TabItem.title),
                    icon: new Icon(TabItem.icon),
                  );
                }).toList(),
              ),
          ),

      );

  void onTap(int tab) {
    _tabController.jumpToPage(tab);
  }

  void onTabChanged(int tab) {
    setState(() {
      this._tab = tab;
    });

    switch (tab) {
      case 0:
        this._title_app = TabItems[0].title;
        break;

      case 1:
        this._title_app = TabItems[1].title;
        break;

      case 2:
        this._title_app = TabItems[2].title;
        break;
    }
  }
}
class TabItem {
  const TabItem({ this.title, this.icon });
  final String title;
  final IconData icon;
}
const List<TabItem> TabItems = const <TabItem>[
  const TabItem(title: 'Service', icon: Icons.home),
  const TabItem(title: 'Favorite', icon: Icons.favorite),
  const TabItem(title: 'Cart', icon: Icons.shopping_cart),
];

