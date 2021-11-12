import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'dart:io' show Platform;



class ErrorButton extends StatelessWidget {
  final String      text;
  final String      title;
  final String      content;
  final Function    sendAlert;

  ErrorButton({
    @required this.text,
    @required this.title,
    @required this.content,
    @required this.sendAlert,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          ),
        ),
        onTap: () {
          //// Alert Dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              /// IOS
              if (Platform.isIOS) {
                return CupertinoAlertDialog(
                  title: Text(this.title),
                  content: Text(this.content),
                  actions: [
                    // NO
                    CupertinoDialogAction(
                      child: Text(
                        AppLocalizations.of(context).translate('no'),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // YES
                    CupertinoDialogAction(
                      child: Text(
                        AppLocalizations.of(context).translate('yes'),
                      ),
                      onPressed: () {
                        //* Send the Alert 'Brand not found!'
                        this.sendAlert();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              }
              /// Android
              return AlertDialog(
                title: Text(this.title),
                content: Text(
                  this.content,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                actions: [
                  // NO
                  FlatButton(
                    child: Text(
                      AppLocalizations.of(context).translate('no'),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // YES
                  FlatButton(
                    child: Text(
                      AppLocalizations.of(context).translate('yes'),
                    ),
                    onPressed: () {
                      //* Send the Alert 'Brand not found!'
                      this.sendAlert();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
          );
        },
      );
  }
}
