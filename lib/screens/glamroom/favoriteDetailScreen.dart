import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mybeautyadvisor/screens/foundation/find_matchs/matchsScreen.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/providers/user.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';
import 'package:mybeautyadvisor/components/iconTextButton.dart';
import 'package:mybeautyadvisor/components/dynamicBottom.dart';
import 'package:mybeautyadvisor/components/bottomNavBar.dart';
import 'package:mybeautyadvisor/components/heartRatingBar.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/customPageRoute.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'models/inventory.dart';
import 'tools/deleteItemAlert.dart';
import 'requests/items.dart';

import 'dart:async';
import 'dart:io';


// Constants
const double    IMAGE_HEIGHT = 190;
const double    RATING_SIZE = 22;




class FavoriteDetailScreen extends StatefulWidget {
  final Product   product;

  FavoriteDetailScreen({ @required this.product });

  @override
  _FavoriteDetailScreenState createState() => _FavoriteDetailScreenState();
}


class _FavoriteDetailScreenState extends State<FavoriteDetailScreen> {
  //* Loading State
  LoadingState      deleteStatus = LoadingState.none;
  LoadingState      editStatus = LoadingState.none;
  //* Show Save button
  bool              isShowSave = false;
  //* new rate value
  double            newRate = 5;


  @override
  Widget build(BuildContext context) {
    Color       successColor = Theme.of(context).primaryColor;
    User        user = Provider.of<UserProvider>(context).user;
    Product     product = widget.product;

    /// submit the new rate value function /////////////////////////////////////////
    editProductRate() async {
      try {
        //* Check Connexion (pinging on GOOGLE server)
        var   result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //* update rate
          editItem(
            productID: product.id,
            user: user,
            newRate: newRate
          ).then(
            (responseStatus) {
              //* If response success
              if (responseStatus == 200) {
                setState(() {
                  editStatus = LoadingState.success;
                });
              }
              //* Token Expired [Logout]
              else if (responseStatus == 401) {
                Provider.of<AuthProvider>(context, listen: false).logout();
                //* Go Home
                MyNavigator.goHome(context);
              }
              //* If response false
              else {
                setState(() {
                  editStatus = LoadingState.error;
                });
              }
              // timer to reset the old value
              Timer(
                Duration(seconds: kTimeResult),
                () {
                  // None
                  setState(() {
                    editStatus = LoadingState.none;
                    // Hide the button on new value
                    isShowSave = false;
                  });
                }
              );
            }
          ).timeout(
            Duration(seconds: kTimeOut),
            onTimeout: () {
              // Timeout
              setState(() {
                editStatus = LoadingState.timeout;
              });
            }
          );
        }
        else {
          setState(() {
            editStatus = LoadingState.timeout;
          });
        }
      } on SocketException catch (_) {
        setState(() {
          editStatus = LoadingState.timeout;
        });
      }
    }
    //////////////////////////////////////////////////////////////////////////////////////
    
    /// delete item function /////////////////////////////////////////////////////////////
    deleteProduct() async {
      try {
        //* Check Connexion (pinging on GOOGLE server)
        var   result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //* delete product
          deleteItem(
            productID: product.id,
            user: user,
          ).then(
            (result) {
              int count = 3;
              //* Close: the Alert Message + the detail product + glamroom
              Navigator.of(context).popUntil((_) => count-- <= 0);
              //* Pop and push the glamroom
              MyNavigator.goGlamroom(context);
            }
          ).timeout(
            Duration(seconds: kTimeOut),
            onTimeout: () {
              setState(() {
                deleteStatus = LoadingState.timeout;
              });
            }
          );
        }
        else {
          //* Remove the pop up
          Navigator.pop(context);
          //* Set state
          setState(() {
            deleteStatus = LoadingState.timeout;
          });
        }
      } on SocketException catch (_) {
        setState(() {
          deleteStatus = LoadingState.timeout;
        });
      }
    }
    //////////////////////////////////////////////////////////////////////////////////////

    //* Go to Matchs Screen    //////////////////////////////////////////////////////////
    void        goToMatchScreen() {
      //* Go to match screen
      Navigator.push(
        context,
        CustomPageRoute(
          builder: (BuildContext context) => MatchsScreen(
            brand: product.brand,
            name: product.name,
            shade: product.shade,
            user: user,
          ),
        ),
      );
    }
    ////////////////////////////////////////////////////////////////////////////////////


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // MBA App bar
        appBar: AppBar(
          toolbarHeight: kToolBarHeight,
          title: LogoMBA(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //* Pop * 2 
              Navigator.pop(context);
              Navigator.pop(context);
              //* Go to glamroom
              MyNavigator.goGlamroom(context);
            },
          ),
        ),

        // Bottom Nav Bar
        bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.glamroom),

        // Body
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(22),
              ),

              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    //// Product Card
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                          
                          // delete Item icon button
                          Container(
                            padding: EdgeInsets.only(bottom: 8),
                            alignment: Alignment.topRight,
                            child: TextButton(
                              child: Icon(
                                (deleteStatus != LoadingState.timeout) ?
                                  CupertinoIcons.trash_fill :
                                  CupertinoIcons.refresh,
                                size: 26,
                                color: Colors.red,
                              ),
                              onPressed: () => deleteItemAlert(context, deleteProduct),
                            ),
                          ),

                            // Image
                            Container(
                              padding: EdgeInsets.all(8),
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
                                (product.imageLargeURL != null) ?
                                  product.imageLargeURL :
                                  kImgLargeNotFound,
                                fit: BoxFit.fitHeight,
                              ),
                            ),

                            // Empty Space
                            SizedBox(height: 5),

                            // Infos
                            Column(
                              children: [
                                //// name
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 18,
                                  ),
                                  child: Text(
                                    product.name,
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
                                  product.brand,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                ),
                                //// shade
                                Text(
                                  product.shade,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            // Empty Space
                            SizedBox(height: 18),

                            // Rate
                            HeartRatingBar(
                              itemSize: getProportionateScreenWidth(RATING_SIZE),
                              initialRating: double.parse(product.rate),
                              onRatingUpdate: (value) {
                                //* Show button if there is new value of rate
                                if (
                                    value != double.parse(product.rate) &&
                                    value != newRate
                                  ){
                                  // Set new rate value
                                  newRate = value;
                                  // Show Button
                                  setState(() {
                                    isShowSave = true;
                                  });
                                }
                              },
                            ),

                          ],
                        ),
                      ),
                    ),

                    //// Empty Space
                    SizedBox(height: getProportionateScreenHeight(15)),

                    //// Timeout Message
                    if (
                      editStatus == LoadingState.timeout ||
                      deleteStatus == LoadingState.timeout
                    )
                      TimeoutIconMessage(),

                    //// Empty Space
                    SizedBox(height: getProportionateScreenHeight(15)),

                    //// Save Rate Dynamic bottom
                    if ( isShowSave )
                      DynamicButtom(
                        textSuccess:  AppLocalizations.of(context).translate('glamroom_change-rate_success'),
                        textError:    AppLocalizations.of(context).translate('glamroom_change-rate_error'),
                        state: editStatus,
                        // Save Botton
                        childWidget: IconTextButton(
                          width: SizeConfig.screenWidth * 0.5,
                          text:
                            (editStatus != LoadingState.timeout) ?
                              AppLocalizations.of(context).translate('save') :
                              AppLocalizations.of(context).translate('retry'),
                          iconData: CupertinoIcons.floppy_disk,
                          color: successColor,
                          press: editProductRate,
                        ),
                      ),

                    //// Find Match
                    if ( !isShowSave )
                      IconTextButton(
                        width: SizeConfig.screenWidth * 0.5,
                        text: AppLocalizations.of(context).translate('matchs_headline'),
                        iconData: CupertinoIcons.search,
                        press: goToMatchScreen,
                      ),

                  ],
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
