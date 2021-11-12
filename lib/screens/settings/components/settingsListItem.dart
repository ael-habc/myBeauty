import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class SettingsListItem extends StatelessWidget {
  final String      text;
  final Widget      childWidget;

  SettingsListItem({
    Key key,
    @required this.text,
              this.childWidget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Text
          Text(
            this.text,
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
          ),
          // Functionality
          this.childWidget,
        ],
      ),
    );
  }
}
