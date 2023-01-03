import 'package:floor/floor.dart';

@Entity(tableName: 'users', indices: [
  Index(
    value: ['username'],
    unique: true,
  )
])
class UserEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: 'username')
  final String username;

  @ColumnInfo(name: 'password')
  final String password;

  @ColumnInfo(name: 'full_name')
  final String fullName;

  @ColumnInfo(name: 'picture_path')
  final String picturePath;

  UserEntity(
    this.id,
    this.username,
    this.password,
    this.fullName,
    this.picturePath,
  );
}
