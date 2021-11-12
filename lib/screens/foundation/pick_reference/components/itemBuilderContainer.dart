import 'package:flutter/material.dart';



class ItemBuilderContainer extends StatelessWidget {
  final String    text;

  ItemBuilderContainer({ @required this.text });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 6,
      ),
      child: Text(
        this.text,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
      ),
    );
  }
}
