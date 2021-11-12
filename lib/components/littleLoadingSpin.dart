import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class LittleLoadingSpin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SpinKitCircle(
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
    );
  }
}
