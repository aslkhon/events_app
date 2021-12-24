import 'package:events_app/core/errors/exceptions.dart';
import 'package:events_app/core/network/url_endpoints.dart';
import 'package:events_app/data/datasources/remote_data_source.dart';
import 'package:events_app/domain/entities/event_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../fixtures/reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late EventsRemoteDataSourceImpl dataSource;
  late MockHttpClient httpClient;
  late UrlEndpoints urls;

  setUp(() {
    httpClient = MockHttpClient();
    urls = const UrlEnpointsImpl();
    dataSource = EventsRemoteDataSourceImpl(httpClient, urls);
  });

  const events = [
    EventEntity(
        name: 'CU Boulder Events',
        referenceUrl: '/guide/171803',
        iconUrl:
            'https://s3.amazonaws.com/media.guidebook.com/service/TxOilTqNztaJfVRBEsutuB1jNwItVh7QxVDU6a9k/logo.png',
        date: 'Jan 01, 2022 - Dec 31, 2022'),
    EventEntity(
        name: '2022 Middle School Winter Conference-Cabell County Schools',
        referenceUrl: '/guide/184558',
        iconUrl:
            'https://s3.amazonaws.com/media.guidebook.com/service/k96NGr1PsmuEPQnNvskk84e28EksCWx2Iv7dqHmF/logo.png',
        date: 'Jan 03, 2022 - Jan 03, 2022'),
    EventEntity(
        name: 'Columbia GS Jumpstart & Orientation - Spring 2022',
        referenceUrl: '/guide/179727',
        iconUrl:
            'https://s3.amazonaws.com/media.guidebook.com/service/6Dcor0Vjf1ngKxTemLy8BHOydKPLA3VyGsOngyJ9/logo.png',
        date: 'Jan 05, 2022 - Jan 16, 2022'),
  ];

  test(
    'should perform a GET request on a URL with application/json header',
    () async {
      // Arrange
      when(() => httpClient.get(urls.getEvents(0, 1),
              headers: any(named: 'headers', that: isA<Map>())))
          .thenAnswer((invocation) => Future.value(
                http.Response(fixture('events.json'), 200),
              ));
      // Act
      await dataSource.getEvents(0, 1);
      // Assert
      verify(() => httpClient.get(urls.getEvents(0, 1),
          headers: {'Content-Type': 'application/json'}));
    },
  );

  test(
    'should throw a request exception when code is 404 or other',
    () async {
      // Arrange
      when(() => httpClient.get(urls.getEvents(0, 1),
              headers: any(named: 'headers', that: isA<Map>())))
          .thenAnswer((invocation) => Future.value(http.Response('''
                  <h1>Not Found</h1>
                  <p>The requested URL was not found on this server.</p>
                  ''', 404)));
      // Act & Assert
      expect(() async => await dataSource.getEvents(0, 1),
          throwsA(isA<RequestException>()));
    },
  );

  test(
    'should throw a type mismatch exception when response is not a list',
    () async {
      // Arrange
      when(() => httpClient.get(urls.getEvents(0, 1),
              headers: any(named: 'headers', that: isA<Map>())))
          .thenAnswer((invocation) => Future.value(
                http.Response(fixture('event.json'), 200),
              ));
      // Act & Assert
      expect(() async => await dataSource.getEvents(0, 1),
          throwsA(isA<TypeMismatchException>()));
    },
  );

  test('should return list of event entities when response is 200', () async {
    // Arrange
    when(() => httpClient.get(urls.getEvents(0, 1),
            headers: any(named: 'headers', that: isA<Map>())))
        .thenAnswer((invocation) => Future.value(
              http.Response(fixture('events.json'), 200),
            ));
    // Act
    final result = await dataSource.getEvents(0, 1);
    // Assert
    expect(result, events);
  });
}
