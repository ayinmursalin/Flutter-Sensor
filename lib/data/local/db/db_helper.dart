import 'package:floor/floor.dart';
import 'package:flutter_sensor/data/local/db/app_database.dart';

class DbHelper {
  static Future<AppDatabase> initializeDatabase() {
    var callback = Callback(
      onCreate: (db, version) {
        db.insert('users', {
          'id': 1,
          'username': 'admin',
          'password': 'admin',
          'full_name': 'Admin',
          'picture_path': '',
        });
      },
    );

    return $FloorAppDatabase
        .databaseBuilder('flutter_sensor.db')
        .addCallback(callback)
        .build();
  }
}
