import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> fetchBookDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/books/$id/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load book detail');
    }
  }
}
