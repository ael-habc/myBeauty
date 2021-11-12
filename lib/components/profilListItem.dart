import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class ProfilListItem extends StatelessWidget {
  final Function    onTap;
  final IconData    icon;
  final String      text;
  final bool        isButton;

  ProfilListItem({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onTap,
              this.isButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(15),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(18),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: getProportionateScreenWidth(30)),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
            ),
            Spacer(),
            if (isButton)
              Icon(
                (AppLocalizations.of(context).locale == Locale('ar')) ?
                  CupertinoIcons.chevron_back :
                  CupertinoIcons.chevron_forward,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
      onPressed: onTap
    );
  }
}