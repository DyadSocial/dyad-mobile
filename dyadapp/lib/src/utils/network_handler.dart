import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/testing.dart';

final http.Client client = MockClient(_handler);

Future<http.Response> _handler(http.Request request) async {
  var content = Map<String, dynamic>.from(
      json.decode(request.body) as Map<String, dynamic>);

  if (content['phone'] == '1234567890' && content['password'] == 'password')
    return http.Response('', 200);

  return http.Response('', 401);
}
