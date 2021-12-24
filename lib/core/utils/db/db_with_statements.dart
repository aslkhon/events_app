import 'sql_statements.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseKit {
  final Database database;
  final SQLStatements statements;

  DataBaseKit({
    required this.database,
    required this.statements,
  });
}
