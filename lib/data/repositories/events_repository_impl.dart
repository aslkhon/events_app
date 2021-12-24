import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/relational_db_source.dart';
import '../datasources/remote_data_source.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;
  final EventsRelationalDBSource localDataSource;
  final NetworkInfo networkInfo;

  EventsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents(
      int startFrom, int count) async {
    late final int numberOfCached;

    try {
      numberOfCached = await localDataSource.getCachedEventsNumber();
    } catch (_) {
      numberOfCached = 0;
    }

    if (numberOfCached >= startFrom + count) {
      try {
        final events = await localDataSource.getCachedEvents(startFrom, count);
        if (events.isEmpty) throw DBException();
        return Right(events);
      } catch (_) {
        // Catch is ignored because either if number of cached evetns is less
        // than intended or exception is throwed program should get events from net
      }
    }

    return await _getFromNet(startFrom, count);
  }

  Future<Either<Failure, List<EventEntity>>> _getFromNet(
      int startFrom, int count) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(Failure.noConnection);
    }

    try {
      final events = await remoteDataSource.getEvents(startFrom, count);

      if (events.isEmpty) {
        return const Left(Failure.noMoreEvents);
      }

      await localDataSource.addEventsToCache(events);
      return Right(events);
    } catch (e) {
      return const Left(Failure.requestFailure);
    }
  }
}
