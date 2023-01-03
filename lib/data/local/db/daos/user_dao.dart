import 'package:floor/floor.dart';
import 'package:flutter_sensor/data/local/db/entities/user_entity.dart';

@dao
abstract class UserDao {

  @Query('SELECT * FROM users WHERE username = :username')
  Future<List<UserEntity>> userList(String username);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> registerUser(UserEntity userEntity);

}
