import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/models/User.dart';


import 'package:mybeautyadvisor/components/logoMBA.dart';
import 'package:mybeautyadvisor/components/bottomNavBar.dart';
import 'package:mybeautyadvisor/components/timeoutBloc.dart';
import 'package:mybeautyadvisor/components/emptyBloc.dart';
import 'package:mybeautyadvisor/components/errorBloc.dart';

import 'package:mybeautyadvisor/constants/inputDecorations.dart';
import 'package:mybeautyadvisor/constants/consts.dart';

import 'package:mybeautyadvisor/tools/customPageRoute.dart';
import 'package:mybeautyadvisor/tools/myLib.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';


import 'components/matchCardProduct.dart';
import 'components/resutLoading.dart';
import 'components/matchsEmpty.dart';
import 'components/npsCard.dart';

import '../pick_reference/requests/getBrands.dart';
import 'requests/nps.dart';


import 'dart:convert';
import 'dart:async';
import 'dart:io';


// Index Global variables
const int     RESULT_INDEX =  0;
const int     NPS_INDEX =  1;





class MatchsScreen extends StatefulWidget {
  final String    brand;
  final String    name;
  final String    shade;
  final User      user;

  MatchsScreen({
    @required this.brand,
    @required this.name,
    @required this.shade,
    @required this.user,
  });

  @override
  _MatchsScreenState createState() => _MatchsScreenState();
}

class _MatchsScreenState extends State<MatchsScreen> {
  // Lists
  List<dynamic>                 listSelectedMatchs = [];
  List<dynamic>                 listMatchs = [];
  List<String>                  listBrands = [];
  // Get Matchs State
  LoadingState                  matchsStatus = LoadingState.loading;
  // Value
  String                        keyword = '';
  // Stack index
  int                           index = RESULT_INDEX;


  @override
  void initState() {
    // Load matchs
    Timer(
      Duration(seconds: kTimeFeelAlgo),
      loadMatchs,
    );
    super.initState();
  }

  // Load Matchs ////////////////////////////////////////////////////////////////////////////////////////
  loadMatchs() async {
    bool    showNPS;
    try {
      //* Check Connexion (pinging on GOOGLE server)
      var   result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Check if I should show the popup
        showNPS = ! await checkNps(widget.user);
        // Get matchs products
        await getProductMatchs();
        // Show the NPS Evaluation
        if (
          showNPS &&
          matchsStatus == LoadingState.success
        )
          Timer(
            Duration(seconds: kTimeNpsShow),
            () {
            setState(() {
              index = NPS_INDEX;
            });
            }
          );
      }
      else {
        setState(() {
          matchsStatus = LoadingState.timeout;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        matchsStatus = LoadingState.timeout;
      });
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  
  //  Get Products matchs     //////////////////////////////////////////////////////////////////////////
  getProductMatchs() async {
    // Product Data
    final Map<String, dynamic>    productData = {
        'brand':    widget.brand,
        'product':  widget.name,
        'shade':    widget.shade,
    };

    // Send request
    Response          response = await post(
      AppUrl.getMatchsURL,
      body: json.encode(productData),
      headers: { 'Content-Type': 'application/json' }
    );

    // Success
    if (response.statusCode == 200) {
      listMatchs = json.decode(response.body);
      // get Brands
      listBrands = await getBrands();
      /// REMOVE NULLS NEED TO BE DELETED WHEN THE db IS CLEAN!
      listBrands.removeWhere((value) => value == null);
      // List selected matchs
      listSelectedMatchs = listMatchs;
      setState(() {
        matchsStatus = LoadingState.success;
      });
    } 
    // Failed
    else {
      var   error = json.decode(response.body)['error'];
      // Empty result
      if (error == "Sorry we can not find your future product, PLease choose other product !")
        setState(() {
          matchsStatus = LoadingState.none;
        });
      // Error failed
      setState(() {
        matchsStatus = LoadingState.error;
      });
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  // get list products that contain the keyword in (brand, name or shade) ////////////////////////////
  List<dynamic>      listOfSearchProducts(List<dynamic> products, String keyword){
    //* Search bar
      return products.where(
        (element) => ( 
                      isContainsIgnoreCase(element['brand'], keyword)   ||
                      isContainsIgnoreCase(element['product'], keyword) ||
                      isContainsIgnoreCase(element['shade'], keyword)
                    )
      ).toList();
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {

    //* Refresh the page   //////////////////////////////////////////////////////////////////////////
    void          refreshPage() {
      // Pop old screen
      Navigator.pop(context);
      // Push same screen
      Navigator.push(
        context,
        CustomPageRoute(
          builder: (BuildContext context) => MatchsScreen(
            brand: widget.brand,
            name: widget.name,
            shade: widget.shade,
            user: widget.user,
          ),
        ),
      );
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////


    return Scaffold(
        // MBA Appbar
        appBar: AppBar(
          toolbarHeight: kToolBarHeight,
          title: LogoMBA(),
        ),
    
        // Bottom Nav Bar
        bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.none),

        // Body
        body: SafeArea(
    
          child: IndexedStack(
            index: index,
            children: [

              /////*  Result
              Column(
                children: <Widget>[

                  //* Loading
                  if (matchsStatus == LoadingState.loading)
                    ResultLoading(),

                  //* Loading
                  if (matchsStatus == LoadingState.none)
                    EmptyBloc(
                      message: AppLocalizations.of(context).translate('matchs_get-result_empty'),
                    ),

                  //* Error
                  if (matchsStatus == LoadingState.error)
                    ErrorBloc(
                      message: AppLocalizations.of(context).translate('matchs_get-result_error'),
                      retryFunction: refreshPage,
                    ),

                  //* Timeout
                  if (matchsStatus == LoadingState.timeout)
                    TimeoutBloc(
                      retryFunction: refreshPage,
                    ),

                  //* Show Results
                  if (matchsStatus == LoadingState.success)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ).copyWith(
                          top: 15,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              //// Headline Panel
                              Text(
                                AppLocalizations.of(context).translate('matchs_headline'),
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  AppLocalizations.of(context).translate('matchs_subtitle'),
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),


                              //// Search Text Field
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 35,
                                ),
                                child: buildKeywordField(),
                              ),

    
                              //// Show matchs
                              (listSelectedMatchs.length == 0) ?
                                //* Empty List
                                MatchsEmpty() :
                                //* List of Items
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: ScrollPhysics(),
                                    child: ListView.builder(
                                      //// fix scroll physics issue
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      ////////////////////////////////////////
                                      itemCount: listSelectedMatchs.length,
                                      itemBuilder: (context, index) {
                                        return MatchCardProduct(
                                          product: listSelectedMatchs[index]
                                        );
                                      }
                                    ),
                                  ),
                                ),
                              SizedBox(height: 8),

                            ],
                        ),
                      ),
                    ),

                ],
              ),


              /////*  NPS Card
              NpsCard(
                goBackFunction: () {
                  setState(() {
                      index = RESULT_INDEX;
                  });
                }
              ),

            ],
          ),

        ),
    );
  }


  //// Search Form       //////////////////////////////////////////
  // Onchange Function
  void      _changeKeyword(value) {
    setState(() {
      keyword = value;
      listSelectedMatchs = listOfSearchProducts(listMatchs, keyword);
    });
  }

  // Form Field
  Widget    buildKeywordField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        cursorColor: Theme.of(context).cursorColor,
        style: Theme.of(context).textTheme.bodyText1,
        onSaved: (newValue) => keyword = newValue,
        onChanged: _changeKeyword,
        decoration: productInputDecoration(
          error:      '',
          labelText:  AppLocalizations.of(context).translate('search'),
          hintText:   AppLocalizations.of(context).translate('hint_search'),
        ),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////

}
