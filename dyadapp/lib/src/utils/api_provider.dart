import 'dart:convert';
import 'package:http/http.dart' as http;

class APIProvider {
  final _baseURL = 'https://api.vncp.me/';
  final http.Client httpClient;
  APIProvider(this.httpClient);
}
