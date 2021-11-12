import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:provider/provider.dart';

import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/providers/auth.dart';
import 'package:mybeautyadvisor/providers/user.dart';

import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';

import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/components/littleLoadingSpin.dart';
import 'package:mybeautyadvisor/components/errorIconMessage.dart';
import 'package:mybeautyadvisor/components/successIconMessage.dart';
import 'package:mybeautyadvisor/components/timeoutIconMessage.dart';

import '../requests/nps.dart';

import 'dart:async';
import 'dart:io';





class NpsCard extends StatefulWidget {
  final Function    goBackFunction;

  NpsCard({
    @required this.goBackFunction,
  });

  @override
  _NpsCardState createState() => _NpsCardState();
}

class _NpsCardState extends State<NpsCard> {
  LoadingState                  npsStatus = LoadingState.none;
  double                        nps = -1;


  @override
  Widget build(BuildContext context) {
    var       user = Provider.of<UserProvider>(context).user;

    // Submit NPS score                 //////////////////////////////////////////////////////////////
    submitNPS() async {
      //* Loading status
      setState(() {
        npsStatus = LoadingState.loading;
      });
      //* Send the NPS score
      try {
        //* Check Connexion (pinging on GOOGLE server)
        var   result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          sendNPS(user, nps).then(
            (responseStatus)  {
              //// Success
              if (responseStatus == 200) {
                setState(() {
                  npsStatus = LoadingState.success;
                });
                // Go to  the next stack
                Timer(
                  Duration(seconds: kTimeResult),
                  widget.goBackFunction,
                );
              }
              //// Token Expired [Logout]
              else if (responseStatus == 401) {
                Provider.of<AuthProvider>(context, listen: false).logout();
                //* Go Home
                MyNavigator.goHome(context);
              }
              //// Fail
              else {
                setState(() {
                  npsStatus = LoadingState.error;
                });
              }
            }
          ).timeout(
            // Timeout
            Duration(seconds: kTimeOut),
            onTimeout: () {
              setState(() {
                npsStatus = LoadingState.timeout;
              });
            }
          );
        }
        else {
          setState(() {
            npsStatus = LoadingState.timeout;
          });
        }
      } on SocketException catch (_) {
        setState(() {
          npsStatus = LoadingState.timeout;
        });
      }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////


    return Center(
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

                    // Card Text
                    Column(
                      children: <Widget> [
                        Text(
                          AppLocalizations.of(context).translate('nps_title'),
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
                          AppLocalizations.of(context).translate('nps_content'),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),

                    // NPS score rate
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //  0: Very dissatisfied
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: (nps == 0) ? Colors.red : CupertinoColors.systemGrey,
                              size: getProportionateScreenWidth(35),
                            ),
                            onPressed: () {
                              if (npsStatus == LoadingState.none)
                                setState(() {
                                  nps = 0;
                                });
                            },
                          ),
                          //  1: Dissatisfied
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_dissatisfied,
                              color: (nps == 1) ? Colors.redAccent : CupertinoColors.systemGrey,
                              size: getProportionateScreenWidth(35),
                            ),
                            onPressed: () {
                              if (npsStatus == LoadingState.none)
                                setState(() {
                                  nps = 1;
                                });
                            },
                          ),
                          //  2: Neutral
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_neutral,
                              color: (nps == 2) ? Colors.amber : CupertinoColors.systemGrey,
                              size: getProportionateScreenWidth(35),
                            ),
                            onPressed: () {
                              if (npsStatus == LoadingState.none)
                                setState(() {
                                  nps = 2;
                                });
                            },
                          ),
                          //  3: Satisfied
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_satisfied,
                              color: (nps == 3) ? Colors.lightGreen : CupertinoColors.systemGrey,
                              size: getProportionateScreenWidth(35),
                            ),
                            onPressed: () {
                              if (npsStatus == LoadingState.none)
                                setState(() {
                                  nps = 3;
                                });
                            },
                          ),
                          //  4: Satisfied
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_very_satisfied,
                              color: (nps == 4) ? Colors.green : CupertinoColors.systemGrey,
                              size: getProportionateScreenWidth(35),
                            ),
                            onPressed: () {
                              if (npsStatus == LoadingState.none)
                                setState(() {
                                  nps = 4;
                                });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Loading Bloc
                    if (npsStatus == LoadingState.loading)
                      LittleLoadingSpin(),

                    // Success Bloc
                    if (npsStatus == LoadingState.success)
                      SuccessIconMessage(
                        message: AppLocalizations.of(context).translate('nps_success'),
                      ),

                    // Error Bloc
                    if (npsStatus == LoadingState.error)
                      ErrorIconMessage(
                        message: AppLocalizations.of(context).translate('nps_error'),
                      ),

                    // Timeout Bloc
                    if (npsStatus == LoadingState.timeout)
                      TimeoutIconMessage(),

                    // Send NPS score Button
                    if (
                      nps != -1 &&
                      npsStatus != LoadingState.success
                    )
                      DefaultButton(
                        width: getProportionateScreenWidth(120),
                        margin: getProportionateScreenHeight(20),
                        text:
                          (npsStatus == LoadingState.error || npsStatus == LoadingState.timeout) ?
                            AppLocalizations.of(context).translate('retry') :
                            AppLocalizations.of(context).translate('submit'),
                        press: submitNPS,
                      ),

                  ],
                ),
              ),
            ),
        ],
      ),
    );

  }
}