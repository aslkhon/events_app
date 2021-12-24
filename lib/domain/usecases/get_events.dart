import '../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../../core/usecases/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class GetEvents implements Usecase<List<EventEntity>, Params> {
  final EventsRepository repository;

  const GetEvents(this.repository);

  @override
  Future<Either<Failure, List<EventEntity>>> call(Params params) async {
    return await repository.getEvents(params.startFrom, params.count);
  }
}

class Params {
  final int startFrom;
  final int count;

  const Params({
    required this.startFrom,
    required this.count,
  });
}
