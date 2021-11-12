import 'package:flutter/material.dart';



class WelcomePanel extends StatelessWidget {
  final String    greeting;
  final String    headline;
  final String    username;

  WelcomePanel({
    @required this.greeting,
    @required this.headline,
    @required this.username
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //// Coucou User
          Row(
            children: <Widget> [
              Text(
                greeting,
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                username,
                style: Theme.of(context).textTheme.headline1.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                " !",
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          //// Message
          Text(
            headline,
            style: Theme.of(context).textTheme.headline2,
          ),
        ],
      ),
    );
  }
}