import 'package:floor/floor.dart';
import 'package:flutter_sensor/app_constant.dart';
import 'package:flutter_sensor/data/local/db/daos/user_dao.dart';
import 'package:flutter_sensor/data/local/db/entities/user_entity.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
  version: AppConstant.version,
  entities: [
    UserEntity
  ],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}
