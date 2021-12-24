part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  final List<EventEntity> events;

  const EventsState(this.events);

  @override
  List<Object?> get props => [events];
}

class EventsInitial extends EventsState {
  final SnackbarError? error;

  const EventsInitial(List<EventEntity> events, {this.error}) : super(events);

  @override
  List<Object?> get props => [error, events];
}

class Loading extends EventsState {
  const Loading(List<EventEntity> events) : super(events);
}
