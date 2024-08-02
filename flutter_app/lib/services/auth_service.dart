import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> logout(String refreshToken) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/logout/member'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'refresh_token': refreshToken,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to logout');
  }
}
