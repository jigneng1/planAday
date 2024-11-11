import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storage = FlutterSecureStorage();

Future<void> storeToken(String token) async {
  await storage.write(key: 'jwt_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'jwt_token');
}

Future<void> clearToken() async {
  await storage.deleteAll();
}

Future<void> clearAllSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool success = await prefs.clear(); // Clear all data
  if (success) {
    print("All data cleared from SharedPreferences");
  } else {
    print("Failed to clear SharedPreferences data");
  }
}

bool isTokenExpired(String token) {
  return JwtDecoder.isExpired(token);
}
