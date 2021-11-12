import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class MiniErrorBloc extends StatelessWidget {
  final String      message;
  final Function    retryFunction;

  MiniErrorBloc({
    @required this.message,
    @required this.retryFunction,
  });

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
                  CupertinoIcons.exclamationmark_octagon_fill,
                  color: Colors.red,
                  size: 16,
                ),
                //// Empty Space
                SizedBox(width: 10),
                //// Message
                Text(
                  this.message,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
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