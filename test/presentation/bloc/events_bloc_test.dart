import 'package:dartz/dartz.dart';
import 'package:events_app/core/errors/failures.dart';
import 'package:events_app/domain/entities/event_entity.dart';
import 'package:events_app/domain/usecases/get_events.dart';
import 'package:events_app/presentation/bloc/events_bloc.dart';
import 'package:events_app/presentation/models/snackbar_error_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetEvents extends Mock implements GetEvents {}

void main() {
  late MockGetEvents getEvents;

  setUp(() {
    getEvents = MockGetEvents();
    registerFallbackValue(const Params(startFrom: 0, count: 3));
  });

  const event = EventEntity(
      name: 'Event',
      referenceUrl: 'www.com',
      iconUrl: 'www.com/img',
      date: 'today - tomorrow');

  const events = [event, event, event];

  blocTest<EventsBloc, EventsState>(
    'should emit [Loading, EventEnitial] without error when data is gotten successfully',
    build: () {
      when(() => getEvents(any()))
          .thenAnswer((invocation) => Future.value(const Right(events)));
      return EventsBloc(getEvents);
    },
    act: (bloc) => bloc.add(LoadEvents()),
    expect: () => [
      const Loading([]),
      const EventsInitial(events),
    ],
  );

  blocTest<EventsBloc, EventsState>(
    'should emit [Loading, EventError] when data is not gotten successfully',
    build: () {
      when(() => getEvents(any())).thenAnswer(
          (invocation) => Future.value(const Left(Failure.requestFailure)));
      return EventsBloc(getEvents);
    },
    act: (bloc) => bloc.add(LoadEvents()),
    expect: () => [
      const Loading([]),
      const EventsInitial([], error: SnackbarError.requestFailure),
    ],
  );

  blocTest<EventsBloc, EventsState>(
    'should emit [Loading, EventError] when no more events can be loaded',
    build: () {
      when(() => getEvents(any())).thenAnswer(
          (invocation) => Future.value(const Left(Failure.noMoreEvents)));
      return EventsBloc(getEvents);
    },
    act: (bloc) => bloc.add(LoadEvents()),
    expect: () => [
      const Loading([]),
      const EventsInitial([], error: SnackbarError.noMoreEvents),
    ],
  );

  blocTest<EventsBloc, EventsState>(
    'should emit [Loading, EventError] when no connection',
    build: () {
      when(() => getEvents(any())).thenAnswer(
          (invocation) => Future.value(const Left(Failure.noConnection)));
      return EventsBloc(getEvents);
    },
    act: (bloc) => bloc.add(LoadEvents()),
    expect: () => [
      const Loading([]),
      const EventsInitial([], error: SnackbarError.noConnection),
    ],
  );
}
