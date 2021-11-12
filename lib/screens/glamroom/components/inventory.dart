import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:mybeautyadvisor/app_localizations.dart';

import 'package:mybeautyadvisor/models/User.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'package:mybeautyadvisor/tools/customPageRoute.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';

import 'package:mybeautyadvisor/components/errorBloc.dart';
import 'package:mybeautyadvisor/components/timeoutBloc.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:provider/provider.dart';

import '../favoriteDetailScreen.dart';
import '../models/inventory.dart';

import 'loadingInventorySpin.dart';
import 'emptyInventory.dart';
import 'productCard.dart';

import 'dart:convert';
import 'dart:async';




class Inventory extends StatefulWidget {
  final User      user;

  Inventory({ @required this.user });

  @override
  _InventoryState createState() => _InventoryState();
}


class _InventoryState extends State<Inventory> {
  InventoryList     inventory;
  LoadingState      status = LoadingState.loading;


  //* Get Inventory from API  */////////////////////////////////
  Future<bool>      getInventory() async {
    var   response = await get(
      AppUrl.getAllItemsURL(widget.user.id),
      headers: {
        'Authorization': 'Bearer ' + widget.user.token,
        'Content-Type': 'application/json'
      }
    );

    // Success
    if (response.statusCode == 200) {
      List<dynamic>   jsonMap = json.decode(response.body);
      inventory = InventoryList.fromJson(jsonMap);
      return true;
    }
    // Expired token [logout]
    else if (response.statusCode == 401) {
      //* Logout from APP Auth
      Provider.of<AuthProvider>(context, listen: false).logout();
      //* Go Home
      MyNavigator.goHome(context);
    }
    // Fail
    return false;
  }
  ////////////////////////////////////////////////////////////////////


  // Load Brands ////////////////////////////////////////////////////////////////////////
  loadinventoryItems() async {
    try {
      //* Check Connexion (pinging on GOOGLE server)
      var   result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Get Inventory Items
        getInventory().then(
          (result) {
            // Set status based on result
            setState(() {
              status = (result) ?
                LoadingState.success :
                LoadingState.error;
            });
          }
        ).timeout(
          Duration(seconds: kTimeOut),
          onTimeout: () {
            // Set status based on result
            setState(() {
              status = LoadingState.timeout;
            });
          }
        );
      }
      else {
        setState(() {
          status = LoadingState.timeout;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        status = LoadingState.timeout;
      });
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////


  @override
  void initState() {
    loadinventoryItems();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    //* Loading
    if (status == LoadingState.loading)
      return LoadingInventorySpin();

    //* Error
    if (status == LoadingState.error)
      return ErrorBloc(
        message: AppLocalizations.of(context).translate('glamroom_error'),
        retryFunction: () => MyNavigator.goGlamroom(context),
      );

    //* Timeout
    if (status == LoadingState.timeout)
      return TimeoutBloc(
        retryFunction: () {
          // Pop old screen
          Navigator.pop(context);
          // Go to Glamroom
          MyNavigator.goGlamroom(context);
        },
      );

    //* Inventory
    return Expanded(
      child:  ( !inventory.isEmpty() ) ?
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
          ).copyWith(
            top: getProportionateScreenHeight(40),
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: inventory.length(),
            itemBuilder: (BuildContext context, int index) {
              //* select product
              final   product = inventory.products[index];
              //* product card
              return ProductCard(
                imageURL: (product.imageLargeURL != null) ?
                  product.imageLargeURL :
                  kImgLargeNotFound,
                name: inventory.products[index].name,
                rate: double.parse(inventory.products[index].rate),
                //* Detail of product
                goToDetail: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      builder: (context) => FavoriteDetailScreen(
                        product: product
                      ),
                    ),
                  );
                }
              );
            },
          ),
        ) :

      // It's empty
      EmptyInventory(),
      
    );
  }
}