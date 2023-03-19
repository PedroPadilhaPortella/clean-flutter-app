import 'package:clean_flutter_app/data/http/http_error.dart';
import 'package:clean_flutter_app/infra/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

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
    PostExpectation mockRequest() => when(
        client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(int statusCode, {String body = '{"key":"value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
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
      await sut.request(url: url, method: 'post');
      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Should return data when post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');
      expect(response, {'key': 'value'});
    });

    test('Should return null when post returns 200 with no data', () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return null when post returns 204', () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return null when post returns 204 but with data', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return badRequest error when post returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return badRequest error when post returns 400', () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return unauthorized error when post returns 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return forbidden error when post returns 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return notFound error when post returns 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return serverError error when post returns 400', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
