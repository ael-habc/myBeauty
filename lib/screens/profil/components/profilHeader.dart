import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';


class ProfilHeader extends StatelessWidget {
  final Widget   imageWidget;
  final String   email;
  final String   name;
  
  ProfilHeader({
    @required this.imageWidget,
    @required this.email,
    @required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(35),
      ),
      child: Column(
          children: <Widget>[

            //// Avatar Picture
            CircleAvatar(
              radius: getProportionateScreenWidth(60),
              backgroundColor: Colors.transparent,
              child: this.imageWidget,
            ),

            //// Name
            Padding(
              padding: EdgeInsets.only(top: 18),
              child: Text(
                this.name,
                style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                ),
              ),
            ),

            //// Email
            Text(
              this.email,
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
            ),

          ],
        ),
    );
  }
}