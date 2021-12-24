import 'package:events_app/core/errors/exceptions.dart';
import 'package:events_app/core/utils/db/db_with_statements.dart';
import 'package:events_app/core/utils/db/sql_statements.dart';
import 'package:events_app/data/datasources/relational_db_source.dart';
import 'package:events_app/data/models/event_model.dart';
import 'package:events_app/domain/entities/event_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

class MockDB extends Mock implements Database {}

void main() {
  late EventRelationalDBSourceImpl datasource;
  late DataBaseKit dbkit;

  setUp(() {
    dbkit = DataBaseKit(database: MockDB(), statements: SQLStatementsImpl());
    datasource = EventRelationalDBSourceImpl(dataBaseKit: dbkit);
  });

  // * Return the number of cached events
  // * Get events from cache
  // * Add event to cache

  const event = EventEntity(
      name: 'Event',
      referenceUrl: 'www.com',
      iconUrl: 'icon.png',
      date: 'Today');
  final rawEvents = [event.toMap(), event.toMap(), event.toMap()];
  final events = [event, event, event];

  group('get cached events number from database', () {
    const key = 'count(*)';

    test(
      'should throw db exception when catches another exception',
      () async {
        // Arrange
        when(() => dbkit.database.rawQuery(any())).thenThrow(Exception());
        // Act & Assert
        expect(() async => await datasource.getCachedEventsNumber(),
            throwsA(isA<DBException>()));
      },
    );

    test(
      'should throw exception when gets wrong map',
      () async {
        // Arrange
        when(() => dbkit.database.rawQuery(any()))
            .thenAnswer((invocation) => Future.value([{}]));
        // Act & Assert
        expect(() async => await datasource.getCachedEventsNumber(),
            throwsA(isA<DBException>()));
      },
    );

    test(
      'should throw exception when gets wrong not int',
      () async {
        // Arrange
        when(() => dbkit.database.rawQuery(any()))
            .thenAnswer((invocation) => Future.value([
                  {key: 1.0}
                ]));
        // Act & Assert
        expect(() async => await datasource.getCachedEventsNumber(),
            throwsA(isA<DBException>()));
      },
    );

    test(
      'should return number of cached events',
      () async {
        // Arrange
        when(() => dbkit.database.rawQuery(any()))
            .thenAnswer((invocation) => Future.value([
                  {key: 3}
                ]));
        // Act
        final result = await datasource.getCachedEventsNumber();
        // Assert
        expect(result, 3);
      },
    );
  });

  group('get events from data base', () {
    final wrongEventMap = {
      'name': 'Event',
      'referenceUrl': 'www.com',
      'iconUrl': 'icon.png',
      'text': 'Today'
    };
    final wrongEvents = [wrongEventMap, wrongEventMap, wrongEventMap];

    test(
      'should return events when get events called',
      () async {
        // Arrange
        when(() => dbkit.database.rawQuery(any()))
            .thenAnswer((invocation) => Future.value(rawEvents));
        // Act
        final result = await datasource.getCachedEvents(0, 3);
        // Assert
        expect(result, events);
      },
    );

    test(
      'should throw an exception when wrong map is received',
      () async {
        // Arrange
        when(() => dbkit.database.rawQuery(any()))
            .thenAnswer((invocation) => Future.value(wrongEvents));
        // Act & Assert
        expect(() async => await datasource.getCachedEvents(0, 3),
            throwsA(isA<DBException>()));
      },
    );

    test(
      'should throw an exception when the list length is not equal to count argument',
      () async {
        // Arrange
        when(() => dbkit.database.rawQuery(any()))
            .thenAnswer((invocation) => Future.value(wrongEvents));
        // Act & Assert
        expect(() async => await datasource.getCachedEvents(0, 4),
            throwsA(isA<DBException>()));
      },
    );
  });
}
