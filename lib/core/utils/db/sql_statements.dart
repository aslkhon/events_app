abstract class SQLStatements {
  String get tableName;

  String createTable();

  String insert(String name, String referenceUrl, String iconUrl, String date);

  String count();

  String readEvents(int startFrom, int count);

  String clearDB();
}

class SQLStatementsImpl implements SQLStatements {
  @override
  String createTable() =>
      "create table Events(name text, referenceUrl text, iconUrl text, date text)";

  @override
  String insert(
          String name, String referenceUrl, String iconUrl, String date) =>
      "insert into Events(name, referenceUrl, iconUrl, date) values ('$name', '$referenceUrl', '$iconUrl', '$date')";

  @override
  String count() => "select count(*) from Events";

  @override
  String readEvents(int startFrom, int count) =>
      "select * from Events limit $count offset $startFrom";

  @override
  String clearDB() => "delete from Events";

  @override
  String get tableName => 'events.db';
}
