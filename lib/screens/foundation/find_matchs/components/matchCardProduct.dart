import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import '../productDetailScreen.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/customPageRoute.dart';

// Image constants
const double    IMAGE_HEIGHT = 80;





class MatchCardProduct extends StatelessWidget {
  final       product;

  MatchCardProduct({ @required this.product });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
        
          //// Image
          leading: Container(
            padding: EdgeInsets.all(5),
            height: getProportionateScreenHeight(IMAGE_HEIGHT),
            width:  getProportionateScreenHeight(IMAGE_HEIGHT),
            decoration: BoxDecoration(
              color: kImageBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: kImageBorderColor,
              ),
            ),
            child: Image.network(
              this.product['thumb_image'] != null ?
                this.product['thumb_image'] :
                kImgThumbNotFound,
              fit: BoxFit.fitHeight,
            ),
          ),
    
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              //// Brand
              Text(
                this.product['brand'],
                maxLines: 1,
                style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 12,
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
          
              //// Product Name
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  this.product['product'],
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 13,
                  ),
                ),
              ),
          
            ],
          ),
        
          //// Shade
          subtitle: Text(
            this.product['shade'],
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Theme.of(context).disabledColor,
              fontSize: 10,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
    
          onTap: () {
            Navigator.push(
              context,
              CustomPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
        ),
      ),
    );
  }
}