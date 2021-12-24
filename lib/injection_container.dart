import 'package:events_app/core/network/network_info.dart';
import 'package:events_app/core/network/url_endpoints.dart';
import 'package:events_app/core/utils/db/db_with_statements.dart';
import 'package:events_app/core/utils/db/sql_statements.dart';
import 'package:events_app/data/datasources/relational_db_source.dart';
import 'package:events_app/data/datasources/remote_data_source.dart';
import 'package:events_app/data/repositories/events_repository_impl.dart';
import 'package:events_app/domain/repositories/events_repository.dart';
import 'package:events_app/domain/usecases/get_events.dart';
import 'package:events_app/presentation/bloc/events_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Bloc
  serviceLocator.registerFactory(() => EventsBloc(serviceLocator()));

  // Use cases
  serviceLocator.registerLazySingleton(() => GetEvents(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator()),
  );

  // Data sources
  serviceLocator.registerLazySingleton<EventsRemoteDataSource>(
      () => EventsRemoteDataSourceImpl(serviceLocator(), serviceLocator()));

  serviceLocator.registerLazySingleton<EventsRelationalDBSource>(
      () => EventRelationalDBSourceImpl(dataBaseKit: serviceLocator()));

  // Core
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // External
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator
      .registerLazySingleton<UrlEndpoints>(() => const UrlEnpointsImpl());

  // Database
  final statements = SQLStatementsImpl();
  final db = await openDatabase(
    statements.tableName,
    version: 1,
    onCreate: (database, version) async {
      database.execute(statements.createTable());
    },
  );
  serviceLocator.registerLazySingleton(
    () => DataBaseKit(database: db, statements: statements),
  );
}
