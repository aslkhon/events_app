import '../../core/errors/exceptions.dart';
import '../../core/utils/db/db_with_statements.dart';
import '../models/event_model.dart';
import '../../domain/entities/event_entity.dart';

abstract class EventsRelationalDBSource {
  Future<int> getCachedEventsNumber();

  Future<List<EventEntity>> getCachedEvents(int startFrom, int count);

  Future<void> addEventsToCache(List<EventEntity> events);
}

class EventRelationalDBSourceImpl implements EventsRelationalDBSource {
  final DataBaseKit dataBaseKit;

  EventRelationalDBSourceImpl({required this.dataBaseKit});

  @override
  Future<void> addEventsToCache(List<EventEntity> events) async {
    try {
      await dataBaseKit.database.transaction((txn) async {
        for (final event in events) {
          await txn.rawInsert(dataBaseKit.statements.insert(
              event.name, event.referenceUrl, event.iconUrl, event.date));
        }
      });
    } catch (_) {
      // TODO: Check it
    }
  }

  @override
  Future<List<EventEntity>> getCachedEvents(int startFrom, int count) async {
    try {
      final statement = dataBaseKit.statements.readEvents(startFrom, count);
      final result = await dataBaseKit.database.rawQuery(statement);
      if (result.length != count) throw DBException();
      return result.map((e) => EventEntityAdapter.fromMap(e)).toList();
    } catch (_) {
      throw DBException();
    }
  }

  @override
  Future<int> getCachedEventsNumber() async {
    try {
      const key = 'count(*)';
      final statement = dataBaseKit.statements.count();
      final result = await dataBaseKit.database.rawQuery(statement);
      return result.first[key] as int;
    } catch (_) {
      throw DBException();
    }
  }
}
