import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static final _settings = ConnectionSettings(
    host: 'mariadb_bookartify',
    port: 3306,
    user: 'bookartify',
    password: 'kLILGiwU9RHUFtkR4rjn',
    db: 'bookartify_db',
  );

  static Future<MySqlConnection> connectToDatabase() async {
    final conn = await MySqlConnection.connect(_settings);
    return conn;
  }
}
