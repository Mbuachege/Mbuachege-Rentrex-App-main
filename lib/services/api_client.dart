// api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final Uri _base;
  final http.Client _client;
  ApiClient({required String baseUrl, http.Client? client})
      : _base = Uri.parse(baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'),
        _client = client ?? http.Client();

  Future<List<dynamic>> getList(String path) async {
    final uri = _base.resolve(path); // <— ALWAYS produces a full URL
    print('GET -> $uri'); // <— log the final full URL
    final res = await _client.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = jsonDecode(res.body);
      if (body is List) return body;
      throw Exception('Expected a JSON array at $uri, got: ${res.body}');
    }
    throw Exception(
        'GET $uri failed: ${res.statusCode} ${res.reasonPhrase}\nBody: ${res.body}');
  }
}
