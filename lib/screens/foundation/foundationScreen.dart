import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mybeautyadvisor/providers/user.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'pick_reference/pickReferenceScreen.dart';
import 'selfie/selfieScreen.dart';



class FoundationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User    user = Provider.of<UserProvider>(
                      context,
                      listen: false
                    ).user;
    
    // If the user  don't have a selfie image
    if (user.photo == null)
      return SelfieScreen();
    
    // If the user have a selfie image
    return PickReferenceScreen();
  }
}
