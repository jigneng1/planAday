import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

bool isTokenExpired(String token) {
  return JwtDecoder.isExpired(token);
}
