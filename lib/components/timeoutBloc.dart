import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class TimeoutBloc extends StatelessWidget {
  final Function    retryFunction;

  TimeoutBloc({ @required this.retryFunction });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              //* timeout Message
              Column(
                children: <Widget>[
                  //// Icon
                  Icon(
                    CupertinoIcons.timer,
                    color: Theme.of(context).disabledColor,
                    size: 32,
                  ),
                  //// Empty Space
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  //// Message
                  Text(
                    AppLocalizations.of(context).translate('timeout'),
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),

              //* Retry Button
              DefaultButton(
                text: AppLocalizations.of(context).translate('retry'),
                width: SizeConfig.screenWidth * 0.3,
                press: this.retryFunction,
              ),

            ],
          ),
        ),
      ),
    );
  }
}