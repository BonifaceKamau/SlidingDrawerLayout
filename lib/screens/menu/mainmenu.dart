import 'package:akiba/models/menu.dart';
import 'package:akiba/routes/routes.dart';
import 'package:akiba/screens/accounts/CurrentAccount/currentAccount.dart';
import 'package:akiba/screens/accounts/CurrentAccount/widgets/currentaccountmenus.dart';
import 'package:akiba/screens/menu/menucardpage.dart';
import 'package:akiba/screens/widgets/drawer/drawer.dart';
import 'package:akiba/service_locator.dart';
import 'package:akiba/services/authenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:akiba/models/side_menu.dart';
import 'package:akiba/models/swipe_animation.dart';
import 'package:akiba/models/model.dart';

import 'package:akiba/models/model.dart';

class MenuPage extends StatefulWidget {
  static const String routeName = '/menu';
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  int currentPage = 0;
  Animation<double> animation;
  AnimationController controller;
  bool isNavigationDrawerOpened = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<SwipeAnimationState> swipeAnimationKey = new GlobalKey();


  AuthService authService = locator<AuthService>();


  @override
  void initState() {
  super.initState();

  controller = AnimationController(
  duration: const Duration(milliseconds: 200), vsync: this);
  animation = Tween<double>(begin: 0, end: 1).animate(controller);
  controller.forward();
  }




  @override
  Widget build(BuildContext context) {
  return SafeArea(
  child: Scaffold(
  body: Stack(
  children: <Widget>[
  SideMenu(
  onMenuItemSelection: (pageIndex) {
  swipeAnimationKey.currentState.hideNavigationDrawer();
  setState(() {
  currentPage = pageIndex;
  });
  },
  ),
  SwipeAnimation(
  key: swipeAnimationKey,
  navigationDrawerOpened: (isOpened) {
  isNavigationDrawerOpened = isOpened;
  if (isNavigationDrawerOpened) {
  controller.reverse();
  } else {
  controller.forward();
  }
  },
  child: Scaffold(
  key: _scaffoldKey,
  appBar: AppBar(
      brightness: Brightness.dark,
  leading: IconButton(
  icon: AnimatedIcon(
  icon: AnimatedIcons.arrow_menu,
  progress: animation,
  ),
  onPressed: () {
  if (isNavigationDrawerOpened) {
  controller.reverse();
  swipeAnimationKey.currentState.hideNavigationDrawer();
  } else {
  controller.forward();
  swipeAnimationKey.currentState.showNavigationDrawer();
  }
  },
  ),
  //title: Text(menuItems[currentPage].menuName),
    title: Text("Akiba"),
  ),

    body: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
//          HeaderPageBackground(
//            showbalance: false,
//            title: "Akiba The evolutionaly banking solution",
//            imgUrl: "assets/images/savings_acc.png",
//          ),
        Expanded(
          child: Column(
            children: <Widget>[
              CurrentAccountMenu(),
              Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 6.0,
                      children: <Widget>[
                        for (final menu in menus)
                          Builder(
                            builder: (context) => GestureDetector(
                              child: MenuCard(menu: menu),
                              onTap: () => {
                                _openPage(menu.title),
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('clicked ' + menu.title),
                                  duration: Duration(seconds: 5),
                                ))
                              },
                            ),
                          )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    ),

 /* body: Container(

  ),*/
  ),
  ),

  ],
  ),
  ),
  );
  }


  _openPage(String title) {
    switch (title) {
      case "Savings Account":
        Navigator.pushReplacementNamed(context, Routes.savingsaccount);
        break;
      case "Current Account":
//        Navigator.pushReplacementNamed(context, Routes.savingsaccount);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CurrentAccount() ));
        break;
      case "Chama Account":
        Navigator.pushReplacementNamed(context, Routes.chamaaccount);
        break;
      case "Cash Transfer":
        Navigator.pushReplacementNamed(context, Routes.cashtransfer);
        break;

      default:
    }
  }
}


//
