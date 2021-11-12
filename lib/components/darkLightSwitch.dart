import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/providers/theme.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:provider/provider.dart';


class DarkLightSwitch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ThemeProvider   theme = Provider.of<ThemeProvider>(context);

    return Container(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 100),
        crossFadeState:
          (Theme.of(context).brightness == Brightness.dark) ?
            CrossFadeState.showFirst :
            CrossFadeState.showSecond,
        firstChild: GestureDetector(
          child: Icon(
            Icons.wb_sunny,
            color: Colors.orange,
          ),
          onTap: () => theme.toggleMode(),
        ),
        secondChild: GestureDetector(
          child: Icon(
            Icons.nights_stay,
            color: Colors.black54,
          ),
          onTap: () => theme.toggleMode(),
        ),
      ),
    );
  }
}