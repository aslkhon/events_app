import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/event_entity.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents(
      int startFrom, int count);
}
