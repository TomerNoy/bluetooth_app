import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// register post request
Future<Map<String, dynamic>> register(Map<String, dynamic> account) async {
  /// add your test domain here
  const String url = 'https://test.add_your_test_domain_here.com';
  const Map<String, String> headers = {"Content-Type": "application/json"};

  final uri = Uri.parse('$url/register');
  try {
    final res = await http
        .post(uri, body: json.encode(account), headers: headers)
        .timeout(
          const Duration(seconds: 20),
          onTimeout: () => http.Response('timeout', 408),
        );

    return {'code': res.statusCode, 'description': 'responded'};
  }

  /// error handling
  on SocketException {
    return {'code': 502, 'description': 'No Internet connection :('};
  } on HttpException {
    return {'code': 500, 'description': 'Couldn\'t connect :o'};
  } on FormatException {
    return {'code': 500, 'description': 'Bad response format :('};
  } on TimeoutException {
    return {'code': 408, 'description': 'request has timed out :('};
  }
}
