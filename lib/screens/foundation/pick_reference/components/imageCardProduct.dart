import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';


// Card constants
const double    CARD_HEIGHT = 200;
const double    CARD_WIDTH = 180;

// Image constants
const double    IMAGE_HEIGHT = 100;




class ImageCardProduct extends StatelessWidget {
  final Function  onTap;
  final String    imageURL;
  final String    name;

  ImageCardProduct({
    @required this.name,
    @required this.imageURL,
    @required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(5),
          width: getProportionateScreenWidth(CARD_WIDTH),
          height: getProportionateScreenHeight(CARD_HEIGHT),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget> [
                    //// Image
                    Container(
                      padding: EdgeInsets.all(10),
                      height: getProportionateScreenHeight(IMAGE_HEIGHT),
                      width:  getProportionateScreenHeight(IMAGE_HEIGHT + 40),
                      decoration: BoxDecoration(
                        color: kImageBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: kImageBorderColor,
                        ),
                      ),
                      child: Image.network(
                        this.imageURL,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    //// name
                    Text(
                      name,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 12,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            ),
          ),
        ),
      );
  }
}