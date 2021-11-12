import 'package:http/http.dart';

import 'package:mybeautyadvisor/models/User.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';

import 'dart:convert';




// Send the NPS score Request       //////////////////////////////////////////////////////////////
Future<bool>          checkNps(User user) async {
  // Send request
  Response          response = await get(
    AppUrl.checkNpsURL(user.id),
    headers: {
      'Authorization': 'Bearer ' + user.token,
      'Content-Type': 'application/json',
    }
  );

  // Get the flag
  var   data = json.decode(response.body);
  return data['flag'];
}
//////////////////////////////////////////////////////////////////////////////////////////////////

// Send the NPS score Request       //////////////////////////////////////////////////////////////
Future<int>          sendNPS(
  User user,
  double nps
) async {
  // Product Data
  final Map<String, dynamic>    npsData = {
      'userid': user.id,
      'nps':    nps.toString(),
  };

  // Send request
  Response          response = await post(
    AppUrl.addNpsURL,
    body: json.encode(npsData),
    headers: {
      'Authorization': 'Bearer ' + user.token,
      'Content-Type': 'application/json',
    }
  );

  // return status
  return response.statusCode;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
