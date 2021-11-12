import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/iconTextButton.dart';
import 'package:mybeautyadvisor/components/logoMBA.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'package:mybeautyadvisor/tools/sharedPreference.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';

import 'components/dynamicSelfieBottom.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';


// Photo enum
enum PhotoPlace       { camera, gallery }





class SelfieScreen extends StatefulWidget {

  @override
  _SelfieScreenState createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<SelfieScreen> {
  LoadingState      photoStatus = LoadingState.none;
  final             picker = ImagePicker();
  int               index = 0;
  File              image;


  @override
  Widget build(BuildContext context) {
    var     user = Provider.of<UserProvider>(context).user;
    var     auth = Provider.of<AuthProvider>(context);


    // update user picture                      /////////////////////////////////////////////////////////
    updateUserPicture({
      File image,
      User user,
    }) async {
      try {
        //* Check Connexion (pinging on GOOGLE server)
        var   result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // Extension of the file
          String    imgExtension = extension(image.path).replaceAll('.', '');
          // Read image as bytes
          final     bytes = image.readAsBytesSync();
          // Encode bytes to Base64
          String    image64Encoded = 'data:image/' + imgExtension + ';base64,' + base64Encode(bytes);

          // Request Data
          final Map<String, dynamic>      requestData = {
            'userid': user.id,
            'photo': image64Encoded
          };

          // Send request
          Response        response = await post(
            AppUrl.editUserPhotoURL,
            body: json.encode(requestData),
            headers: {
              'Authorization': 'Bearer ' + user.token,
              'Content-Type': 'application/json',
            }
          );

          // Success
          if (response.statusCode == 200) {
            var     jsonData = json.decode(response.body);
            String  imageURL = jsonData['url'];
            // Set Photo for the provider
            Provider.of<UserProvider>(context, listen: false).setPhoto(imageURL);
            // Set in locale
            await UserPreferences().setPhoto(imageURL);
            // Set image success
            return LoadingState.success;
          }
          //* Expired token [logout]
          else if (response.statusCode == 401) {
            //* Logout from APP Auth
            Provider.of<AuthProvider>(context, listen: false).logout();
            //+ Go Home
            MyNavigator.goHome(context);
          }
          // Fail
          return LoadingState.error;
        }
        // Timeout
        return LoadingState.timeout;
      } on SocketException catch (_) {
        // On Socket Exception Timeout
        return LoadingState.timeout;
      }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    //////  IMAGE functions    ////////////////////////////////////////////////////////////////////////////
    // Delete Image
    void      deleteImage() {
      setState(() {
        image.delete();
        image = null;
      });
    }

    // Take Image
    void      takePicture(PhotoPlace photoPlace) {
      // Pick picture
      picker.getImage(
        source: (photoPlace == PhotoPlace.camera) ?
          ImageSource.camera :
          ImageSource.gallery
      ).then(
        (pickedImage) {
          if (pickedImage == null)
            return;
          //Set image
          setState(() {
            image = File(pickedImage.path);
          });
        }
      );
    }
    ////////////////////////////////////////////////////////////////////////////////////////



    return Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolBarHeight,
          title: LogoMBA(),
        ),
        body: SafeArea(
          child: IndexedStack(
            index: index,
            children: [
              
              //Selfie Card
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: SizeConfig.screenWidth * 0.8,
                          padding: EdgeInsets.all(
                            getProportionateScreenWidth(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [

                              // Selfie Text
                              Column(
                                children: <Widget> [
                                  Text(
                                    AppLocalizations.of(context).translate('selfie_title'),
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(20),
                                  ),
                                  //* Content
                                  Text(
                                    AppLocalizations.of(context).translate('selfie_message'),
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),

                              // Continue Button
                              DefaultButton(
                                width: getProportionateScreenWidth(120),
                                margin: getProportionateScreenHeight(20),
                                text: AppLocalizations.of(context).translate('selfie_next'),
                                press: () {
                                  setState(() { index++; });
                                },
                              ),

                              // Skip Button
                              GestureDetector(
                                child: Text(
                                  AppLocalizations.of(context).translate('selfie_skip'),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  MyNavigator.goPickReference(context);
                                },
                              ),

                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),


              // Take Picture Part
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical:   getProportionateScreenHeight(20),
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    
                    //// Exemple Screen
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(20),
                      ),
                      child: 
                      (image == null) ?
                        Container(
                          height: SizeConfig.screenHeight * 0.5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).primaryColorLight,
                              width: 5,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                'assets/images/face.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ) :
                        //// Show picked Image
                        Container(
                          height: SizeConfig.screenHeight * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(image),
                          ),
                        ),
                      ),

                    (image == null) ?
                      //// Buttons (Take selfie + Gallerie)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //* Take Selfie Button
                            Container(
                              child: IconTextButton(
                                text: AppLocalizations.of(context).translate('take-picture_take-selfie'),
                                iconData: Icons.camera,
                                width: SizeConfig.screenWidth * 0.65,
                                press: () {
                                  // Take picture from gallery
                                  takePicture(PhotoPlace.camera);
                                },
                              ),
                            ),
                            //* Space
                            SizedBox(height: 12),
                            //* Take from gallerie Button
                            Container(
                              child: IconTextButton(
                                text: AppLocalizations.of(context).translate('take-picture_take-gallery'),
                                iconData: Icons.image,
                                color: Colors.pink[300],
                                width: SizeConfig.screenWidth * 0.65,
                                press: () {
                                  // Take picture from gallery
                                  takePicture(PhotoPlace.gallery);
                                },
                              )
                            ),
                          ],
                        ),
                      ) :
                      //// Buttons (Good to Go + delete and go back)
                      Expanded(
                        child: DynamicSelfieBottom(
                          state: photoStatus,
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //* Take Selfie Button
                              Container(
                                child: IconTextButton(
                                  text: AppLocalizations.of(context).translate('take-picture_use'),
                                  iconData: Icons.check,
                                  color: kFuzzyWuzzyColor,
                                  width: SizeConfig.screenWidth * 0.65,
                                  press: () {
                                    // Loading State
                                    setState(() {
                                      photoStatus = LoadingState.loading;
                                    });
                                    // Save selfie image
                                    updateUserPicture(
                                      user: user,
                                      image: image
                                    ).then(
                                      (result) {
                                        // Set the status
                                        setState(() {
                                          photoStatus = result;
                                        });
                                        // Set timer to affect state ==> none
                                        Timer(
                                          Duration(seconds: kTimeResult),
                                          () {
                                            // None
                                            setState(() {
                                              photoStatus = LoadingState.none;
                                            });
                                            // Go to the next screen
                                            if (result == LoadingState.success)
                                              MyNavigator.goPickReference(context);
                                          }
                                        );
                                      }
                                    ).timeout(
                                      Duration(seconds: kTimeOut),
                                      onTimeout: () {
                                        setState(() {
                                          photoStatus = LoadingState.timeout;
                                        });
                                      }
                                    );
                                  },
                                ),
                              ),
                              //* Space
                              SizedBox(height: 12),
                              //* Delete Button
                              Container(
                                child: IconTextButton(
                                  text: AppLocalizations.of(context).translate('take-picture_delete'),
                                  iconData: Icons.delete,
                                  color: kBlastBronzeColor,
                                  width: SizeConfig.screenWidth * 0.65,
                                  press: deleteImage,
                                )
                              ),
                            ],
                          ),
                        ),
                      ),

                  ],
                ),
              ),
  
            ],
          ),
      ),
    );
  }
}
