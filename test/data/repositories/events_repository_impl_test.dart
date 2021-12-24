import 'package:dartz/dartz.dart';
import 'package:events_app/core/errors/exceptions.dart';
import 'package:events_app/core/errors/failures.dart';
import 'package:events_app/core/network/network_info.dart';
import 'package:events_app/data/datasources/relational_db_source.dart';
import 'package:events_app/data/datasources/remote_data_source.dart';
import 'package:events_app/data/repositories/events_repository_impl.dart';
import 'package:events_app/domain/entities/event_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements EventsRemoteDataSource {}

class MockLocalDataSource extends Mock implements EventsRelationalDBSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late EventsRepositoryImpl repository;
  late MockRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = EventsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  const event = EventEntity(
      name: 'Event',
      referenceUrl: 'www.com',
      iconUrl: 'www.com/img',
      date: 'today - tomorrow');

  const events = [event, event, event];

  test(
    'should return list of events from db when the number of cached events is more that index of requested events',
    () async {
      when(() => localDataSource.getCachedEventsNumber())
          .thenAnswer((invocation) => Future.value(3));
      when(() => localDataSource.getCachedEvents(any(), any()))
          .thenAnswer((invocation) => Future.value(events));

      final result = await repository.getEvents(0, 3);

      expect(result, const Right(events));
      verifyNever(() => remoteDataSource.getEvents(any(), any()));
    },
  );

  group('could not load from cache', () {
    setUp(() {
      when(() => networkInfo.isConnected)
          .thenAnswer((invocation) => Future.value(true));
      when(() => remoteDataSource.getEvents(any(), any()))
          .thenAnswer((invocation) => Future.value(events));
    });

    test(
      'should call get events from net when the number of cached events is less that index of requested events',
      () async {
        when(() => localDataSource.getCachedEventsNumber())
            .thenAnswer((invocation) => Future.value(0));

        await repository.getEvents(0, 3);

        verify(() => remoteDataSource.getEvents(any(), any()));
      },
    );

    test(
      'should call get events from net when local data storage returns an empty list',
      () async {
        // Arrange
        when(() => localDataSource.getCachedEventsNumber())
            .thenAnswer((invocation) => Future.value(3));
        when(() => localDataSource.getCachedEvents(any(), any()))
            .thenAnswer((invocation) => Future.value([]));
        // Act
        await repository.getEvents(0, 3);
        // Assert
        verify(() => remoteDataSource.getEvents(any(), any()));
      },
    );

    test(
      'should call get events from net when local data storage get events method throws DBException',
      () async {
        // Arrange
        when(() => localDataSource.getCachedEventsNumber())
            .thenAnswer((invocation) => Future.value(3));
        when(() => localDataSource.getCachedEvents(any(), any()))
            .thenThrow(DBException());
        // Act
        await repository.getEvents(0, 3);
        // Assert
        verify(() => remoteDataSource.getEvents(any(), any()));
      },
    );
  });

  group('get events from net', () {
    setUp(() {
      when(() => localDataSource.getCachedEventsNumber())
          .thenAnswer((invocation) => Future.value(0));
    });

    const requestException =
        RequestException(reason: 'Test Request Exception', statusCode: 0);

    test(
      'should return 3 events from and save them in local db the net when online',
      () async {
        // Arrange
        when(() => networkInfo.isConnected)
            .thenAnswer((invocation) => Future.value(true));
        when(() => remoteDataSource.getEvents(any(), any()))
            .thenAnswer((invocation) => Future.value(events));
        when(() => localDataSource.addEventsToCache(events))
            .thenAnswer((invocation) async {});
        // Act
        final result = await repository.getEvents(0, 3);
        // Assert
        expect(result, const Right(events));
        verify(() => localDataSource.addEventsToCache(events));
      },
    );

    test(
      'should return noConnection failure when offline',
      () async {
        // Arrange
        when(() => networkInfo.isConnected)
            .thenAnswer((invocation) => Future.value(false));
        // Act
        final result = await repository.getEvents(0, 3);
        // Assert
        expect(result, const Left(Failure.noConnection));
      },
    );

    test(
      'should return noMoreEvents failure when empty list is returned',
      () async {
        // Arrange
        when(() => networkInfo.isConnected)
            .thenAnswer((invocation) => Future.value(true));
        when(() => remoteDataSource.getEvents(any(), any()))
            .thenAnswer((invocation) => Future.value([]));
        // Act
        final result = await repository.getEvents(0, 3);
        // Assert
        expect(result, const Left(Failure.noMoreEvents));
      },
    );

    test(
      'should return reqest failure when exception is thrown in remote data source get events',
      () async {
        // Arrange
        when(() => networkInfo.isConnected)
            .thenAnswer((invocation) => Future.value(true));
        when(() => remoteDataSource.getEvents(any(), any()))
            .thenThrow(requestException);
        // Act
        final result = await repository.getEvents(0, 3);
        // Assert
        expect(result, const Left(Failure.requestFailure));
      },
    );
  });
}
