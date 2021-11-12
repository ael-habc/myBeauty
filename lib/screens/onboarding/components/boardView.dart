import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class BoardView extends StatelessWidget {
  final List<Widget>      children;

  BoardView({ @required this.children });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
    );
  }
}
