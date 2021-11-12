import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';



class BottomNavBar extends StatelessWidget {
  
  BottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.home,
                  color: MenuState.home == selectedMenu
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                  size: MenuState.home == selectedMenu ? 26 : 20,
                ),
                onPressed: () {
                  if (ModalRoute.of(context).settings.name != '/') {
                    // Pop until the first page of the app
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.heart_fill,
                  color: MenuState.glamroom == selectedMenu
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                  size: MenuState.glamroom == selectedMenu ? 26 : 20,
                ),
                onPressed: () {
                  MyNavigator.goGlamroom(context);
                },
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.person_fill,
                  color: MenuState.account == selectedMenu
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                  size: MenuState.account == selectedMenu ? 26 : 20,
                ),
                onPressed: () {
                  MyNavigator.goProfile(context);
                },
              ),
            ],
          )),
    );
  }
}