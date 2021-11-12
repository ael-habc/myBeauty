import 'package:http/http.dart';

import 'package:mybeautyadvisor/models/User.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';

import 'dart:convert';




Future<String>        refreshToken(User user) async {
  final Map<String, dynamic>  userData = {
    'userid': user.id,
  };

  //* Send request
  var   response = await post(
    AppUrl.refreshTokenURL,
    body: json.encode(userData),
    headers: {
      'Authorization': 'Bearer ' + user.token,
      'Content-Type': 'application/json'
    }
  );

  //* Affect response
  if (response.statusCode == 200) {
    final Map<String, dynamic>    responseBody = json.decode(response.body);
    return responseBody['token'];
  }
  return null;
}