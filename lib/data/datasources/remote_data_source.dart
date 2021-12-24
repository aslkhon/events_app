import 'dart:convert';

import '../../core/errors/exceptions.dart';
import '../../core/network/url_endpoints.dart';
import '../models/event_model.dart';
import '../../domain/entities/event_entity.dart';
import 'package:http/http.dart' as http;

abstract class EventsRemoteDataSource {
  Future<List<EventEntity>> getEvents(int startFrom, int count);
}

class EventsRemoteDataSourceImpl extends EventsRemoteDataSource {
  final http.Client client;
  final UrlEndpoints urls;

  EventsRemoteDataSourceImpl(this.client, this.urls);

  @override
  Future<List<EventEntity>> getEvents(int startFrom, int count) async {
    final response = await client.get(urls.getEvents(startFrom, count),
        headers: {'Content-Type': 'application/json'});

    switch (response.statusCode) {
      case 200:
        final body = json.decode(response.body);
        if (body['data'] == null || body['data'] is! List) {
          throw TypeMismatchException();
        }
        List<EventEntity> events = [];
        for (final rawEvent in body['data']) {
          final eventModel = EventModel.fromMap(rawEvent);
          events.add(EventEntityAdapter.fromModel(eventModel));
        }
        return events;
      case 400:
        throw RequestException.badRequest;
      case 404:
        throw RequestException.notFound;
      case 500:
        throw RequestException.serverError;
      default:
        throw RequestException(
            reason: 'Undefined status code', statusCode: response.statusCode);
    }
  }
}
