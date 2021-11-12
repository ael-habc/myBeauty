import 'package:flutter/material.dart';

import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'logo.dart';



// Customized App Bar
class LogoMBA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //// Logo
      child: Logo(
        padding: 10,
        height: getProportionateScreenHeight(90),
      ),
      //// Go Home
      onTap: () {
        if (ModalRoute.of(context).settings.name != '/') {
          // Pop until the first page of the app
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );
  }
}