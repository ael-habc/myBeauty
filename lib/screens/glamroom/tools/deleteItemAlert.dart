import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'dart:io';



void      deleteItemAlert(
    BuildContext context, Function deleteProduct
  ) {
  //// Alert PopUp
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      /// IOS
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context).translate('glamroom_delete-item_title'),
          ),
          content: Text(
            AppLocalizations.of(context).translate('glamroom_delete-item_content'),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context).translate('no'),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context).translate('yes'),
              ),
              //* delete item
              onPressed: deleteProduct,
            ),
          ],
        );
      }
      /// Android
      return AlertDialog(
        title: Text(
            AppLocalizations.of(context).translate('glamroom_delete-item_title'),
          ),
          content: Text(
            AppLocalizations.of(context).translate('glamroom_delete-item_content'),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('no'),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('yes'),
              ),
              //* delete item
              onPressed: deleteProduct,
            ),
          ],
      );
    },
  );
}