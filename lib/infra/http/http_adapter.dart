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
    final jsonBody = body != null ? jsonEncode(body) : null;

    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await client.post(
      Uri.dataFromString(url),
      headers: headers,
      body: jsonBody,
    );

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}
