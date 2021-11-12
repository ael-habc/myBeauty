import 'package:http/http.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'dart:convert';



Future<bool>      requestOTPcode(String email) async {
  // Data
  final Map<String, dynamic>    infosData = {
      'email': email,
  };

  // Send request
  Response          response = await post(
    AppUrl.getOtpURL,
    body: json.encode(infosData),
    headers: {
      'Content-Type':   'application/json',
    }
  );

  // return status
  return (response.statusCode == 200);
}
