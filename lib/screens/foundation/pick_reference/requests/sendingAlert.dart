import 'package:http/http.dart';
import 'package:mybeautyadvisor/tools/appUrl.dart';
import 'dart:convert';



// Sending Alert Request
Future<bool>    sendAlert({
  String owner,
  String subject,
  String description
}) async {
  // Product Data
  final Map<String, dynamic>    requestData = {
      'email':        owner,
      'subject':      subject,
      'description':  description,
  };

  // Send request
  Response          response = await post(
    AppUrl.sendAlertURL,
    body: json.encode(requestData),
    headers: { 'Content-Type': 'application/json' }
  );

  return response.statusCode == 200;
}