import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class MiniTimeoutBloc extends StatelessWidget {
  final Function    retryFunction;

  MiniTimeoutBloc({ @required this.retryFunction });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: getProportionateScreenHeight(35),
        ).copyWith(
          bottom: getProportionateScreenHeight(15),
        ),
        child: Column(
          children: <Widget>[

            //* timeout Message
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //// Icon
                Icon(
                  CupertinoIcons.timer,
                  color: Theme.of(context).disabledColor,
                  size: 16,
                ),
                //// Empty Space
                SizedBox(width: 10),
                //// Message
                Text(
                  AppLocalizations.of(context).translate('timeout'),
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ),

            //// Empty Space
            SizedBox(height: 10),

            //* Retry Button
            DefaultButton(
              text: AppLocalizations.of(context).translate('retry'),
              fontSize: 13,
              press: this.retryFunction,
            ),

          ],
        ),
      ),
    );
  }
}