import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'package:mybeautyadvisor/tools/sharedPreference.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/models/User.dart';

import 'dart:async';
import 'dart:convert';


enum  Status {
  NotLoggedIn,
  NotRegistred,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut,
}



//  Autheentication Provider                                      ////////////////////////////////
class   AuthProvider with ChangeNotifier {

  Status  _loggedInStatus = Status.NotLoggedIn;
  Status  _registeredStatus = Status.NotRegistred;

  Status  get loggedInStatus => _loggedInStatus;
  Status  get registeredStatus => _registeredStatus;

  void    setLoggedIn() {
    _loggedInStatus = Status.LoggedIn;
  }

  void    setNotifyLoggedIn() {
    _loggedInStatus = Status.LoggedIn;
    notifyListeners();
  }

  void    setNotLoggedIn() {
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();
  }
  
  void    setNotRegistered() {
    _registeredStatus = Status.NotRegistred;
    notifyListeners();
  }


  //// Login method /////////////////////////////////////////
  Future<Map<String, dynamic>>    login(String email, String password) async {
  
    final Map<String, dynamic>  loginData = {
        'email': email,
        'mdp': password
    };

    // Change status ==> Auth
    _loggedInStatus = Status.Authenticating;
    notifyListeners();
  
    // Send request
    Response  response = await post(
      AppUrl.loginURL,
      body: json.encode(loginData),
      headers: { 'Content-Type': 'application/json' }
    );

    // Success
    if (response.statusCode == 200) {
      final Map<String, dynamic>  responseBody = json.decode(response.body);
      var                         userData = responseBody['user'];
      userData['token'] = responseBody['token'];

      User    authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      // Change status ==> Logged in
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      return {
        'status': true,
        'message': 'Login Successfully',
        'user': authUser
      };
    }
        
    // Failed
    else {
      // Change status ==> Not Logged in
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();

      return {
        'status': false,
        'message': 'error'
      };
    }
  }
  ////////////////////////////////////////////////////////////////////////////

  //// Register method   /////////////////////////////////////////////////////
  Future<Map<String, dynamic>>   register(
      String name,
      String phone,
      String email,
      String password
  ) async {
    var     result;
    
    final Map<String, dynamic>  registrationData = {
      'prenom': name,
      'email': email,
      'phone': phone,
      'mdp': password,
    };

    // Change Status ==> Registering
    _registeredStatus = Status.Registering;
    notifyListeners();

    //Wait request
    var   response = await post(
      AppUrl.registerURL,
      body: json.encode(registrationData),
      headers: { 'Content-Type': 'application/json' }
    );

    // Success
    if (response.statusCode == 200) {
      final Map<String, dynamic>  responseBody = json.decode(response.body);
      var                         userData = responseBody['user'];
      userData['token'] = responseBody['token'];

      User    authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      // Change status ==> Logged in
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {
        'status': true,
        'message': 'Successfully registered',
        'user': authUser
      };
    }
    // Fail
    else {
      result = {
        'status': false,
        'message': 'Registration failed',
      };
    }
  
    // Change status ==> Not registring
    _registeredStatus = Status.NotRegistred;
    notifyListeners();
  
    return result;
  }


  //  Logout method   ///////////////////////////////////////////////
  void      logout() async {
    // Remove from cache
    UserPreferences().removeUser();

    //* Sign out google account
    try {
      await GoogleSignIn().disconnect();
    } on Exception catch (e) {
      print("No google account to signout: $e");
    }
    //* Signout facebook account
    try {
      await FacebookLogin().logOut();
    } on Exception catch (e) {
      print("No Facebook account to signout: $e");
    }

    // Change status ==> Logged in
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();
  }

}
///////////////////////////////////////////////////////////////////////////////////