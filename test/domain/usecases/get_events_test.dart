import 'package:dartz/dartz.dart';
import 'package:events_app/domain/entities/event_entity.dart';
import 'package:events_app/domain/repositories/events_repository.dart';
import 'package:events_app/domain/usecases/get_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventsRepository extends Mock implements EventsRepository {}

void main() {
  late GetEvents usecase;
  late EventsRepository repository;

  const event = EventEntity(
      name: 'Event',
      referenceUrl: 'www.com',
      iconUrl: 'www.com/img',
      date: 'today - tomorrow');

  const events = [event, event, event];

  setUp(() {
    repository = MockEventsRepository();
    usecase = GetEvents(repository);
  });

  test(
    'should get list of events from the repository',
    () async {
      when(() => repository.getEvents(any(), any()))
          .thenAnswer((invocation) async => const Right(events));

      final result = await usecase.call(const Params(startFrom: 0, count: 3));

      expect(result, const Right(events));
      verify(() => repository.getEvents(0, 3));
      verifyNoMoreInteractions(repository);
    },
  );
}
