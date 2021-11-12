import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';



class SuccessBloc extends StatelessWidget {
  final String      message;

  SuccessBloc({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    Color   successColor = Theme.of(context).primaryColor;
  
    return Container(
      height: SizeConfig.screenHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: SizeConfig.screenWidth * 0.8,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                    Icon(
                      CupertinoIcons.check_mark_circled,
                      color: successColor,
                      size: 70,
                    ),

                    //// Empty Space
                    SizedBox(height: 40),

                    //// Message
                    Text(
                      this.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}