import 'package:flutter/material.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';


const double    CARD_IMG_HEIGHT = 160;
const double    CARD_IMG_WIDTH = 250;



class CategoryCard extends StatelessWidget {
  final String    imgPath;
  final String    title;

  //// Constructor
  CategoryCard({
    @required   this.imgPath,
    @required   this.title
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget> [

                //// Image in the colored container
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Image.asset(
                    imgPath,
                    height: getProportionateScreenHeight(CARD_IMG_HEIGHT),
                    width: getProportionateScreenWidth(CARD_IMG_WIDTH),
                    fit: BoxFit.fitHeight,
                  ),
                ),

                //// Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),
          ),
      ),
    );
  }
}
