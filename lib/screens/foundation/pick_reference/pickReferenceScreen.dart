import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/providers/user.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'package:mybeautyadvisor/tools/customPageRoute.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/myLib.dart';

import 'package:mybeautyadvisor/components/dynamicBottom.dart';
import 'package:mybeautyadvisor/components/littleLoadingSpin.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/bottomNavBar.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';
import 'package:mybeautyadvisor/components/loadingSpinBloc.dart';
import 'package:mybeautyadvisor/components/timeoutBloc.dart';
import 'package:mybeautyadvisor/components/errorBloc.dart';
import 'package:mybeautyadvisor/components/miniTimeoutBloc.dart';
import 'package:mybeautyadvisor/components/miniErrorBloc.dart';

import 'package:mybeautyadvisor/constants/inputDecorations.dart';
import 'package:mybeautyadvisor/constants/consts.dart';

import 'components/itemBuilderContainer.dart';
import 'components/imageCardProduct.dart';
import 'components/errorButton.dart';

import '../find_matchs/matchsScreen.dart';

import 'models/product.dart';
import 'models/teinte.dart';

import 'requests/saveInGlamroom.dart';
import 'requests/sendingAlert.dart';
import 'requests/getBrands.dart';


import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'dart:io';






class PickReferenceScreen extends StatefulWidget {
  @override
  _PickReferenceScreenState createState() => _PickReferenceScreenState();
}

class _PickReferenceScreenState extends State<PickReferenceScreen> {
  // Box Controllers
  SuggestionsBoxController    _brandSuggestionsBoxController = SuggestionsBoxController();
  SuggestionsBoxController    _nameSuggestionsBoxController = SuggestionsBoxController();
  SuggestionsBoxController    _shadeSuggestionsBoxController = SuggestionsBoxController();
  // Text Controllers
  TextEditingController       _brandController = TextEditingController();
  TextEditingController       _nameController = TextEditingController();
  TextEditingController       _shadeController = TextEditingController();
  // Alert Message Loading State
  LoadingState                alertStatus = LoadingState.none;
  LoadingState                savedStatus = LoadingState.none;
  // Get Data State
  LoadingState                brandStatus = LoadingState.loading;
  LoadingState                nameStatus = LoadingState.none;
  LoadingState                shadeStatus = LoadingState.none;
  bool                        cantSaveProduct = false;
  // Values
  String                      brand = '';
  String                      name = '';
  String                      shade = '';
  // Focus Nodes
  FocusNode                   nameFocusNode;
  FocusNode                   shadeFocusNode;
  // List of all items
  List<String>                allBrands;
  List<String>                allNames;
  List<String>                allShades;
  // List of ( product name + image )
  ProductsList                allProducts;
  // List of ( shades + id's )
  TeintesList                  allTeintes;
  // List of ( product name + image )
  // that will be shown in image selection field
  ProductsList                showProducts;
  // The Dropdown state
  Map<String, bool>           isOpen = {
                                'brand': false,
                                'name': false,
                                'shade': false,
                              };
  // Errors
  Map<String, String>         errors = {
                                'brand': '',
                                'name': '',
                                'shade': '',
                              };
  // Unknown values by user
  Map<String, String>         unknownValue = {
                                'brand': '',
                                'name': '',
                                'shade': '',
                              };




  //* Get Products names of a given brand from API  *////////////////////////
  Future<bool>    getNamesAndImages(String brand) async {
    var   response = await get(
      AppUrl.getProductsURL(brand),
      headers: { 'Content-Type': 'application/json' }
    );

    // Success
    if (response.statusCode == 200) {
      List<dynamic>   jsonMap = json.decode(response.body);

      setState(() {
        allProducts = ProductsList.fromJson(jsonMap);
        allNames = [];
        jsonMap.forEach((element) {
          allNames.add(element['nom']);
        });
      });
      // Success
      return true;
    }
    // Fail
    return false;
  }
  ////////////////////////////////////////////////////////////////////////////
  
  //* GetShades and Ids of a given product name from API  *///////////////////
  Future<bool>      getShadesAndIds(String name) async {
    var   response = await get(
      AppUrl.getShadesURL(name),
      headers: { 'Content-Type': 'application/json' }
    );

    // Success
    if (response.statusCode == 200) {
      List<dynamic>   jsonMap = json.decode(response.body);

      setState(() {
        allTeintes = TeintesList.fromJson(jsonMap);
        allShades = [];
        jsonMap.forEach((element) {
          allShades.add(element['teinte']);
        });
      });
      // Success
      return true;
    }
    // Fail
    return false;
  }
  /////////////////////////////////////////////////////////////////////////////

  // Load Brands //////////////////////////////////////////////////////////////
  loadBrands() async {
    try {
      //* Check Connexion (pinging on GOOGLE server)
      var   result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Get Brands
        getBrands().then(
          (result) {
            // Success
            if (result.length > 0) {
              setState(() {
                /// REMOVE NULLS NEED TO BE DELETED WHEN THE db IS CLEAN!
                result.removeWhere((value) => value == null);
                allBrands = result;
                brandStatus = LoadingState.success;
              });
            }
            // Error
            else {
              setState(() {
                brandStatus = LoadingState.error;
              });
            }
          }
        ).timeout(
          Duration(seconds: kTimeOut),
          onTimeout: () {
            setState(() {
              brandStatus = LoadingState.timeout;
            }); 
          }
        );
      }
      else {
        setState(() {
          brandStatus = LoadingState.timeout;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        brandStatus = LoadingState.timeout;
      });
    }
  }
  /////////////////////////////////////////////////////////////////////////////

  @override
  void  initState() {
    loadBrands();
    nameFocusNode = FocusNode();
    shadeFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameFocusNode.dispose();
    shadeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var     user = Provider.of<UserProvider>(context).user;

    //* Go to Matchs Screen    ////////////////////////////////////////////////
    void        goToMatchScreen() {
      //* Reset State
      setState(() {
        savedStatus = LoadingState.none;
      });
      //* Go to match screen
      Navigator.push(
        context,
        CustomPageRoute(
          builder: (BuildContext context) => MatchsScreen(
            brand: brand,
            name: name,
            shade: shade,
            user: user,
          ),
        ),
      );
    }
    ///////////////////////////////////////////////////////////////////////////

    //* Refresh the page   ///////////////////////////////////////////////////
    void          refreshPage() {
      // Pop previous page\
      Navigator.pop(context);
      // Push new page
      MyNavigator.goPickReference(context);
    }
    //////////////////////////////////////////////////////////////////////////

    //////  On Suggestion Selected                ////////////////////////////
    //* Brand Suggestion selected function
    void      _brandOnSuggestionSelected(String suggestion) async {
      try {
        //* Set Input field text = the selected text
        _brandController.text = suggestion;
        //* Check Connexion
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //* Enable loading next
          setState(() {
            nameStatus = LoadingState.loading;
          });
          //* Wait All the Name+Images data of 'brand' from API
          getNamesAndImages(suggestion).then(
            (result) {
              // Success
              if (result) {
                //* Change State of brand
                setState(() {
                  nameStatus = LoadingState.success;
                  brand = suggestion;
                  isOpen['brand'] = false;
                  errors['brand'] = '';
                });
                //* The products that will be shown in the image section == All products
                showProducts = allProducts;
                //* Focus on Name Text Field
                nameFocusNode.requestFocus();
              }
              else {
                // Error get name state
                setState(() {
                  nameStatus = LoadingState.error;
                });
              }
            } 
          ).timeout(
            Duration(seconds: kTimeOut),
            onTimeout: () {
              setState(() {
                nameStatus = LoadingState.timeout;
              });
            }
          );
        }
        else {
          setState(() {
            nameStatus = LoadingState.timeout;
          });
        }
      } on SocketException catch (_) {
        setState(() {
          nameStatus = LoadingState.timeout;
        });
      }
    }

    //* Product name Suggestion selected function
    void      _nameOnSuggestionSelected(suggestion) async {
      try {
        //* Check Connexion
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //* Enable loading next
          setState(() {
            shadeStatus = LoadingState.loading;
            //* Set Input field text = the selected text
            _nameController.text = suggestion;
          });
          //* Wait All the Shades+Ids data of 'brand' from API
          getShadesAndIds(suggestion).then(
            (result) {
              // Success
              if (result) {
                //* Set Name State
                setState(() {
                  shadeStatus = LoadingState.success;
                  name = suggestion;
                  isOpen['name'] = false;
                  errors['name'] = '';
                });
                //* Focus on Name Text Field
                shadeFocusNode.requestFocus();
              }
              // Fail
              else {
                // Error get name state
                setState(() {
                  shadeStatus = LoadingState.error;
                });
              }
            }
          ).timeout(
            Duration(seconds: kTimeOut),
            onTimeout: () {
              setState(() {
                shadeStatus = LoadingState.timeout;
              });
            }
          );
        }
        else {
          setState(() {
            shadeStatus = LoadingState.timeout;
          });
        }
      } on SocketException catch (_) {
        setState(() {
          shadeStatus = LoadingState.timeout;
        });
      }
    }
    //////////////////////////////////////////////////////////////////////////

    // Save Item function   //////////////////////////////////////////////////
    void      saveItem() async {
      try {
        //* Check Connexion (pinging on GOOGLE server)
        var   result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // Set Loading state
          setState(() {
            savedStatus = LoadingState.loading;
          });
          // Save product
          saveProductInGlamroom(
            allTeintes.getID(shade),
            user
          ).then(
            (responseStatus) {
              //* Success
              if (responseStatus == 200)
                setState(() {
                  savedStatus = LoadingState.success;
                });
              //* Token Expired [Logout]
              else if (responseStatus == 401) {
                Provider.of<AuthProvider>(context, listen: false).logout();
                //* Go Home
                MyNavigator.goHome(context);
              }
              //* Failed
              else
                setState(() {
                  savedStatus = LoadingState.error;
                });
              //* After 1s => go to Match Screen
              Timer(
                Duration(seconds: 1),
                goToMatchScreen
              );
            }
          ).timeout(
            Duration(seconds: kTimeOut),
            onTimeout: () {
              setState(() {
                savedStatus = LoadingState.error;
              });
              //* After 1s => go to Match Screen
              Timer(
                Duration(seconds: 1),
                goToMatchScreen
              );
            }
          );
        }
        else {
          setState(() {
            savedStatus = LoadingState.timeout;
          });
        }
      } on SocketException catch (_) {
        setState(() {
          savedStatus = LoadingState.timeout;
        });
      }
    }
    //////////////////////////////////////////////////////////////////////////


    return Scaffold(
      // MBA App bar
      appBar: AppBar(
        toolbarHeight: kToolBarHeight,
        title: LogoMBA(),
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.home),

      // Body
      body: Column(
          children: [

            //* Loading
            if (brandStatus == LoadingState.loading)
              LoadingSpinBloc(),

            //* Error
            if (brandStatus == LoadingState.error)
              ErrorBloc(
                message: AppLocalizations.of(context).translate('pick-ref_get-brand_error'),
                retryFunction: refreshPage,
              ),

            //* Timeout
            if (brandStatus == LoadingState.timeout)
              TimeoutBloc(
                retryFunction: refreshPage,
              ),

            //* Show Screen
            if (brandStatus == LoadingState.success)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20),
                    ).copyWith(
                     top: getProportionateScreenHeight(40)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //// Headline
                        Text(
                          AppLocalizations.of(context).translate('pick-ref_headline'),
                          style: Theme.of(context).textTheme.headline2.copyWith(
                            fontSize: 20,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(50)),

                        //// Body
                        Column(
                          children: <Widget> [

                            //// Brand Field Form     ////////////////////////////////////////////////////////////////////
                            if (brandStatus == LoadingState.success)
                              Padding(
                                padding: EdgeInsets.only(bottom: getProportionateScreenHeight(30)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        //* Text Input
                                        Expanded(
                                          child: TypeAheadField(
                                            textFieldConfiguration: TextFieldConfiguration(
                                              style: Theme.of(context).textTheme.bodyText1,
                                              controller: _brandController,
                                              decoration: productInputDecoration(
                                                error: errors['brand'],
                                                labelText:  AppLocalizations.of(context).translate('product-brand'),
                                                hintText:   AppLocalizations.of(context).translate('hint_product-brand'),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  name = '';
                                                  shade = '';
                                                  _nameController.text = '';
                                                  _shadeController.text = '';
                                                  errors['name'] = '';
                                                  errors['shade'] = '';
                                                  brand = '';
                                                  //* Set name error
                                                  if (allBrands.where((element) => isContainsIgnoreCase(element, value)).toList().length == 0) {
                                                    errors['brand'] = AppLocalizations.of(context).translate('error_product-brand-unknown');
                                                    unknownValue['brand'] = value;
                                                  }
                                                  else
                                                    errors['brand'] = '';
                                                });
                                              },
                                            ),
                                            suggestionsBoxController: _brandSuggestionsBoxController,
                                            hideSuggestionsOnKeyboardHide: false,
                                            hideOnError: true,
                                            hideOnEmpty: true,
                                            suggestionsCallback: (pattern) {
                                              return allBrands.where((element) => isContainsIgnoreCase(element, pattern));
                                            },
                                            itemBuilder: (context, suggestion) {
                                              isOpen['brand'] = true;
                                              return ItemBuilderContainer(text: suggestion);
                                            },
                                            onSuggestionSelected: _brandOnSuggestionSelected,
                                          ),
                                        ),
                                        //* Open/Close Suggestion Box button
                                        IconButton(
                                          icon: Icon(
                                            isOpen['brand'] && brand.isEmpty ?
                                              CupertinoIcons.chevron_up :
                                              CupertinoIcons.chevron_down,
                                            size: 18,
                                            color: (errors['brand'].isEmpty) ?
                                              Theme.of(context).primaryColor :
                                              Theme.of(context).scaffoldBackgroundColor,
                                          ),
                                          onPressed: () {
                                            if (errors['brand'].isNotEmpty)
                                              return ;
                                            setState(() {
                                              isOpen['brand'] = !_brandSuggestionsBoxController.isOpened();
                                            });
                                            _brandSuggestionsBoxController.toggle();
                                          },
                                        ),
                                      ],
                                    ),
                                    //* Button to report that you didn't found the product brand
                                    if ( errors['brand'].isNotEmpty )
                                      Padding(
                                        padding: EdgeInsets.all(getProportionateScreenHeight(20)),
                                        child: DynamicButtom(
                                          state: alertStatus,
                                          textSuccess:  AppLocalizations.of(context).translate('help-support_success'),
                                          textError:    AppLocalizations.of(context).translate('help-support_error'),
                                          childWidget: ErrorButton(
                                            text:     AppLocalizations.of(context).translate('pick-ref_404-text_product-brand'),
                                            title:    AppLocalizations.of(context).translate('pick-ref_404-title_product-brand'),
                                            content:  AppLocalizations.of(context).translate('pick-ref_404-content_product-brand'),
                                            sendAlert: () {
                                              //* Loading Status
                                              setState(() {
                                                alertStatus = LoadingState.loading;
                                              });
                                              //* Set Owner
                                              String    owner = Provider.of<UserProvider>(context, listen: false).user.email;
                                              //* Send Alert
                                              sendAlert(
                                                owner: owner,
                                                subject: 'Brand not found',
                                                description: '[User: $owner] didn\'t find a the [brand: ${unknownValue['brand']}]',
                                              ).then(
                                                (status) {
                                                  //* Set State
                                                  setState(() {
                                                    alertStatus = status ?
                                                        LoadingState.success :
                                                        LoadingState.error;
                                                  });
                                                  //* timer to reset the old value
                                                  Timer(
                                                    Duration(seconds: kTimeResult),
                                                    () {
                                                      // None
                                                      setState(() {
                                                        alertStatus = LoadingState.none;
                                                      });
                                                    }
                                                  );
                                                }
                                              );
                                            }
                                          ),
                                        ),
                                      ),
                                    
                                    //* Loading Name
                                    if (nameStatus == LoadingState.loading)
                                      Padding(
                                        padding: EdgeInsets.all(30),
                                        child: LittleLoadingSpin(),
                                      ),

                                    //* Error Name
                                    if (nameStatus == LoadingState.error)
                                      MiniErrorBloc(
                                        message: AppLocalizations.of(context).translate('pick-ref_get-name_error'),
                                        retryFunction: () {
                                          _brandOnSuggestionSelected(_brandController.text);
                                        }
                                      ),

                                    //* Timeout Name
                                    if (nameStatus == LoadingState.timeout)
                                      MiniTimeoutBloc(
                                        retryFunction: () {
                                          _brandOnSuggestionSelected(_brandController.text);
                                        },
                                      ),
                                      
                                  ],
                                ),
                              ),
                            ///////////////////////////////////////////////////////////////////////////////////////////////////


                          //// Products Names Field Form   //////////////////////////////////////////////////////////////////
                          if (brand.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: getProportionateScreenHeight(30),
                              ),
                              child: Column(
                                children: [

                                  ////* Select product by images
                                  if (
                                      name.isEmpty &&
                                      showProducts != null &&
                                      shade.isEmpty
                                    )
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 15,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: showProducts.products.map((element) =>
                                            // Product Select Card
                                            GestureDetector(
                                              child: ImageCardProduct(
                                                imageURL: element.imageLargeURL != null ?
                                                  element.imageLargeURL :
                                                  kImgLargeNotFound,
                                                name:     element.name,
                                                onTap: () async {
                                                  try {
                                                    //* Set Input field text = the selected text
                                                    _nameController.text = element.name;
                                                    //* Check Connexion
                                                    final result = await InternetAddress.lookup('google.com');
                                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                      //* Enable loading next
                                                      setState(() {
                                                        shadeStatus = LoadingState.loading;
                                                      });
                                                      //* Get All the shades data of 'name' from API
                                                      getShadesAndIds(element.name).then(
                                                        (result) {
                                                          // Success
                                                          if (result) {
                                                            //* Set Name State
                                                            setState(() {
                                                              shadeStatus = LoadingState.success;
                                                              name = element.name;
                                                              isOpen['name'] = false;
                                                              errors['name'] = '';
                                                            });
                                                          }
                                                          // Fail
                                                          else {
                                                            // Error get name state
                                                            setState(() {
                                                              shadeStatus = LoadingState.error;
                                                            });
                                                          }
                                                        }
                                                      ).timeout(
                                                        Duration(seconds: kTimeOut),
                                                        onTimeout: () {
                                                          setState(() {
                                                            shadeStatus = LoadingState.timeout;
                                                          });
                                                        }
                                                      );
                                                    }
                                                    else {
                                                      setState(() {
                                                        shadeStatus = LoadingState.timeout;
                                                      });
                                                    }
                                                  } on SocketException catch (_) {
                                                    setState(() {
                                                      shadeStatus = LoadingState.timeout;
                                                    });
                                                  }
                                                } 
                                              ),
                                            )).toList(),
                                        ),
                                      ),
                                    ),

                                  ////* Text Field
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          //* Text input
                                          Expanded(
                                            child: TypeAheadField(
                                              textFieldConfiguration: TextFieldConfiguration(
                                                focusNode: nameFocusNode,
                                                style: Theme.of(context).textTheme.bodyText1,
                                                enabled: brand.isNotEmpty,
                                                controller: _nameController,
                                                decoration: productInputDecoration(
                                                  error: errors['name'],
                                                  labelText:  AppLocalizations.of(context).translate('product-name'),
                                                  hintText:   AppLocalizations.of(context).translate('hint_product-name'),
                                                ),
                                                onChanged: (value) => {
                                                  setState(() {
                                                    //* Empty Name & Shade
                                                    shade = '';
                                                    _shadeController.text = '';
                                                    errors['shade'] = '';
                                                    name = '';
                                                    //* Create the Products that will be shown in the horizontal-scroll
                                                    showProducts = ProductsList.fromList(
                                                      (allProducts.products.where(
                                                        (element) => isContainsIgnoreCase(element.name, value)
                                                      )).toList()
                                                    );
                                                    //* Set or reset name error
                                                    if (showProducts.isEmpty()) {
                                                      errors['name'] = AppLocalizations.of(context).translate('error_product-name-unknown');
                                                      unknownValue['name'] = value;
                                                    }
                                                    else
                                                      errors['name'] = '';
                                                  })
                                                },
                                              ),
                                              suggestionsBoxController: _nameSuggestionsBoxController,
                                              hideSuggestionsOnKeyboardHide: false,
                                              hideOnError: true,
                                              hideOnEmpty: true,
                                              suggestionsCallback: (pattern) {
                                                return (allNames.where((element) => isContainsIgnoreCase(element, pattern))).cast<String>();
                                              },
                                              itemBuilder: (context, suggestion) {
                                                isOpen['name'] = true;
                                                return ItemBuilderContainer(text: suggestion);
                                              },
                                              onSuggestionSelected: _nameOnSuggestionSelected,
                                            ),
                                          ),
                                          //* Open/Close Suggestion Box button
                                          IconButton(
                                            icon: Icon(
                                              isOpen['name'] && name.isEmpty ?
                                                CupertinoIcons.chevron_up :
                                                CupertinoIcons.chevron_down,
                                              size: 18,
                                              color: (errors['name'].isEmpty) ?
                                                Theme.of(context).primaryColor :
                                                Theme.of(context).scaffoldBackgroundColor,
                                            ),
                                            onPressed: () {
                                              if (errors['name'].isNotEmpty)
                                                return;
                                              setState(() {
                                                isOpen['name'] = !_nameSuggestionsBoxController.isOpened();
                                              });
                                              _nameSuggestionsBoxController.toggle();
                                            },
                                          ),
                                        ],
                                      ),

                                      //* Button to report that you didn't found the product name
                                      if ( errors['name'].isNotEmpty )
                                        Padding(
                                          padding: EdgeInsets.all(getProportionateScreenHeight(20)),
                                          child: DynamicButtom(
                                            state: alertStatus,
                                            textSuccess:  AppLocalizations.of(context).translate('help-support_success'),
                                            textError:    AppLocalizations.of(context).translate('help-support_error'),
                                            childWidget: ErrorButton(
                                              text:     AppLocalizations.of(context).translate('pick-ref_404-text_product-name'),
                                              title:    AppLocalizations.of(context).translate('pick-ref_404-title_product-name'),
                                              content:  AppLocalizations.of(context).translate('pick-ref_404-content_product-name'),
                                              sendAlert: () {
                                                //* Loading Status
                                                setState(() {
                                                  alertStatus = LoadingState.loading;
                                                });
                                                //* Set Owner
                                                String    owner = Provider.of<UserProvider>(context, listen: false).user.email;
                                                //* Send Alert
                                                sendAlert(
                                                  owner: owner,
                                                  subject: 'Product name not found',
                                                  description: '[User: $owner] didn\'t find the product [name: ${unknownValue['name']}], of the brand "${unknownValue['brand']}"',
                                                ).then(
                                                  (status) {
                                                    //* Set State
                                                    setState(() {
                                                      alertStatus = status ?
                                                          LoadingState.success :
                                                          LoadingState.error;
                                                    });
                                                    //* timer to reset the old value
                                                    Timer(
                                                      Duration(seconds: kTimeResult),
                                                      () {
                                                        // None
                                                        setState(() {
                                                          alertStatus = LoadingState.none;
                                                        });
                                                      }
                                                    );
                                                  }
                                                );
                                              }
                                            ),
                                          ),
                                        ),
                                      
                                      //* Loading Shade
                                      if (shadeStatus == LoadingState.loading)
                                        Padding(
                                          padding: EdgeInsets.all(30),
                                          child: LittleLoadingSpin(),
                                        ),

                                      //* Error Shade
                                      if (shadeStatus == LoadingState.error)
                                        MiniErrorBloc(
                                          message: AppLocalizations.of(context).translate('pick-ref_get-shade_error'),
                                          retryFunction: () {
                                            _nameOnSuggestionSelected(_nameController.text);
                                          },
                                        ),

                                      //* Timeout Shade
                                      if (shadeStatus == LoadingState.timeout)
                                        MiniTimeoutBloc(
                                          retryFunction: () {
                                            _nameOnSuggestionSelected(_nameController.text);
                                          },
                                        ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ///////////////////////////////////////////////////////////////////////////////////////////////


                          //// Shade Field Form   ///////////////////////////////////////////////////////////////////////
                          if (name.isNotEmpty)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    //* Text Input
                                    Expanded(
                                      child: TypeAheadField(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          focusNode: shadeFocusNode,
                                          style: Theme.of(context).textTheme.bodyText1,
                                          controller: _shadeController,
                                          enabled: name.isNotEmpty,
                                          decoration: productInputDecoration(
                                            error: errors['shade'],
                                            labelText:  AppLocalizations.of(context).translate('product-shade'),
                                            hintText:   AppLocalizations.of(context).translate('hint_product-shade'),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              // Empty => Shade
                                              shade = '';
                                              //* Set or reset name error
                                              if (allShades.where((element) => isContainsIgnoreCase(element, value)).toList().length == 0) {
                                                errors['shade'] = AppLocalizations.of(context).translate('error_product-shade-unknown');
                                                unknownValue['shade'] = value;
                                              }
                                              else
                                                errors['shade'] = '';
                                            });
                                          },
                                        ),
                                        suggestionsBoxController: _shadeSuggestionsBoxController,
                                        hideSuggestionsOnKeyboardHide: false,
                                        hideOnError: true,
                                        hideOnEmpty: true,
                                        direction: AxisDirection.up,
                                        //autoFlipDirection: true,
                                        suggestionsCallback: (pattern) {
                                          return allShades.where((element) => isContainsIgnoreCase(element, pattern));
                                        },
                                        itemBuilder: (context, suggestion) {
                                          isOpen['shade'] = true;
                                          return ItemBuilderContainer(text: suggestion);
                                        },
                                        onSuggestionSelected: (suggestion) {
                                          if (suggestion == shade)
                                            return;
                                          //* Set Input field text = the selected text
                                          _shadeController.text = suggestion;
                                          setState(() {
                                            shade = suggestion;
                                            isOpen['shade'] = false;
                                            errors['shade'] = '';
                                          });
                                        },
                                      ),
                                    ),
                                    //* Open/Close Suggestion Box button
                                    IconButton(
                                      icon: Icon(
                                        isOpen['shade'] && shade.isEmpty?
                                          CupertinoIcons.chevron_up :
                                          CupertinoIcons.chevron_down,
                                        size: 18,
                                        color: (errors['shade'].isEmpty) ?
                                          Theme.of(context).primaryColor :
                                          Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      onPressed: () {
                                        if (errors['shade'].isNotEmpty)
                                          return;
                                        setState(() {
                                          isOpen['shade'] = !_shadeSuggestionsBoxController.isOpened();
                                        });
                                        _shadeSuggestionsBoxController.toggle();
                                      },
                                    ),
                                  ],
                                ),
                                //* Button to report that you didn't found the product shade
                                if ( errors['shade'].isNotEmpty )
                                  Padding(
                                    padding: EdgeInsets.all(getProportionateScreenHeight(20)),
                                    child: DynamicButtom(
                                      state: alertStatus,
                                      textSuccess:  AppLocalizations.of(context).translate('help-support_success'),
                                      textError:    AppLocalizations.of(context).translate('help-support_error'),
                                      childWidget: ErrorButton(
                                        text:     AppLocalizations.of(context).translate('pick-ref_404-text_product-shade'),
                                        title:    AppLocalizations.of(context).translate('pick-ref_404-title_product-shade'),
                                        content:  AppLocalizations.of(context).translate('pick-ref_404-content_product-shade'),
                                        sendAlert: () {
                                          //* Loading Status
                                          setState(() {
                                            alertStatus = LoadingState.loading;
                                          });
                                          //* Set Owner
                                          String    owner = Provider.of<UserProvider>(context, listen: false).user.email;
                                          //* Sending Alert
                                          sendAlert(
                                            owner: owner,
                                            subject: 'Shade not found',
                                            description: '[User: $owner] didn\'t find the [shade: ${unknownValue['shade']}], in the product name "${unknownValue['name']}" of the brand "${unknownValue['brand']}"',
                                          ).then(
                                            (status) {
                                              //* Set State
                                              setState(() {
                                                alertStatus = status ?
                                                    LoadingState.success :
                                                    LoadingState.error;
                                              });
                                              //* timer to reset the old value
                                              Timer(
                                                Duration(seconds: kTimeResult),
                                                () {
                                                  // None
                                                  setState(() {
                                                    alertStatus = LoadingState.none;
                                                  });
                                                }
                                              );
                                            }
                                          );
                                        }
                                      ),
                                    ),
                                  ),

                                  //// Empty Space
                                  SizedBox(
                                    height: getProportionateScreenHeight(25)
                                  ),

                                  //// Timeout message
                                  if (savedStatus == LoadingState.timeout)
                                    TimeoutIconMessage(),
                        
                              ],
                            ),
                          //////////////////////////////////////////////////////////////////////////////////////////


                          //// Empty space
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),


                          //// Submit Button
                          if ( brand.isNotEmpty && name.isNotEmpty && shade.isNotEmpty )
                            DynamicButtom(
                              textSuccess:  AppLocalizations.of(context).translate('pick-ref_save-item_success'),
                              textError:    AppLocalizations.of(context).translate('pick-ref_save-item_error'),
                              state: savedStatus,
                              // Save Botton
                              childWidget: DefaultButton(
                                text: (savedStatus != LoadingState.timeout) ?
                                  AppLocalizations.of(context).translate('pick-ref_next') :
                                  AppLocalizations.of(context).translate('retry'),
                                width: SizeConfig.screenWidth * 0.5,
                                press: saveItem,
                              ),
                            ),

                        ],
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
