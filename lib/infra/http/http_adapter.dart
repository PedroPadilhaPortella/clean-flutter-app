import 'dart:convert';
import 'package:clean_flutter_app/data/http/http.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(Uri.dataFromString(url),
        headers: headers, body: jsonBody);

    return response.body.isEmpty || response.statusCode == 204
        ? null
        : jsonDecode(response.body);
  }
}
