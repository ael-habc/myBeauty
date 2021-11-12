import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/bottomNavBar.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';


// Image const
const double    IMAGE_HEIGHT = 190;


class ProductDetailScreen extends StatelessWidget {
  final   product;

  ProductDetailScreen({ @required this.product });


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // MBA App bar
      appBar: AppBar(
        toolbarHeight: kToolBarHeight,
        title: LogoMBA(),
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.none),

      // Body
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(25),
              vertical: getProportionateScreenHeight(20),
            ),

            //// Product Card
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Title:
                Text(
                  AppLocalizations.of(context).translate('matchs_product-details'),
                  style: Theme.of(context).textTheme.headline1,
                ),

                // Card:
                SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                          
                            // Image
                            Container(
                              padding: EdgeInsets.all(10),
                              height: getProportionateScreenHeight(IMAGE_HEIGHT),
                              width:  getProportionateScreenHeight(IMAGE_HEIGHT + 60),
                              decoration: BoxDecoration(
                                color: kImageBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: kImageBorderColor,
                                ),
                              ),
                              child: Image.network(
                                this.product['large_image'] != null ?
                                  this.product['large_image'] :
                                  kImgLargeNotFound,
                                fit: BoxFit.fitHeight,
                              ),
                            ),

                            // Empty Space
                            SizedBox(height: 15),

                            // Infos
                            Column(
                              children: [
                                //// name
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 25,
                                  ),
                                  child: Text(
                                    product['product'],
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                //// brand
                                Text(
                                  product['brand'],
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                ),
                                SizedBox(height: 10),
                                //// shade
                                Text(
                                  product['shade'],
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),

          ),
        ),
      ),
    );
  
  }
}
