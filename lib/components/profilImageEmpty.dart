import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';


class ProfilImageEmpty extends StatelessWidget {
  final String    userName;
  final double    radius;

  ProfilImageEmpty({
    @required this.userName,
              this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: kNoAvatarColor,
      radius: this.radius,
      child: Text(
        this.userName[0],
        style: TextStyle(
          color: Colors.white,
          fontSize: this.radius - 10,
        ),
      ),
    );
  }
}