import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';


Widget    indicator(bool isActive) {

  return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      width: isActive ? 24 : 16,
      decoration: BoxDecoration(
        color: isActive ? kPrimaryColor : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
}
