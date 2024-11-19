import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkUtility {
  static Future<Map<String, dynamic>?> fetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
