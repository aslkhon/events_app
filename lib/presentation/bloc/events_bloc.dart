import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/get_events.dart';
import '../models/snackbar_error_model.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  static const _numberPerLoad = 3;

  final GetEvents getEvents;

  EventsBloc(this.getEvents) : super(const EventsInitial([])) {
    on<LoadEvents>(_loadEvents);
  }

  void _loadEvents(LoadEvents event, Emitter<EventsState> emit) async {
    if (state is! EventsInitial) return;

    emit(Loading(state.events));

    final result = await getEvents(
        Params(startFrom: state.events.length, count: _numberPerLoad));

    result.fold((failure) {
      SnackbarError? error;

      const undefinedError = SnackbarError(message: 'Undefined error');

      switch (failure) {
        case Failure.noConnection:
          error = SnackbarError.noConnection;
          break;
        case Failure.noMoreEvents:
          error = SnackbarError.noMoreEvents;
          break;
        case Failure.requestFailure:
          error = SnackbarError.requestFailure;
          break;
        case Failure.undefinedFailure:
          error = undefinedError;
      }

      emit(EventsInitial(state.events, error: error ?? undefinedError));
    }, (loaded) {
      emit(EventsInitial(state.events + loaded));
    });
  }
}
