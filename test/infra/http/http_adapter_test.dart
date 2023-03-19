import 'dart:convert';

import 'package:clean_flutter_app/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
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

    return response.body.isEmpty ? null : jsonDecode(response.body);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    test('Should call post with correct values', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('{"key":"value"}', 200));

      await sut.request(url: url, method: 'post', body: {'key': 'value'});

      verify(client.post(
        Uri.dataFromString(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: '{"key":"value"}',
      ));
    });

    test('Should call post without a body', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('{"key":"value"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Should return data when post returns 200', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => Response('{"key":"value"}', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, {'key': 'value'});
    });

    test('Should return null when post returns 200 with no data', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => Response('', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
  });
}
