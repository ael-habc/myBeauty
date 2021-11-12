import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/components/heartRatingBar.dart';


// Image constants
const double    IMAGE_HEIGHT = 105;



class ProductCard extends StatelessWidget {
  final Function  goToDetail;
  final String    imageURL;
  final String    name;
  final double    rate;

  ProductCard({
    @required this.goToDetail,
    @required this.imageURL,
    @required this.name,
    @required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //* Go to detail
      onTap: this.goToDetail,
      //* Product Card
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
                  padding: EdgeInsets.all(8),
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
                  this.name,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 12,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),


                //// Rate
                HeartRatingBar(
                  itemSize: 15,
                  initialRating: this.rate,
                  ignoreGestures: true,
                )

              ],
            ),
        ),
        ),
    );
  }
}