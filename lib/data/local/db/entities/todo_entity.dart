import 'package:floor/floor.dart';

@Entity(tableName: 'todos')
class TodoEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: 'label')
  final String label;

  @ColumnInfo(name: 'created_at')
  final DateTime createdAt;

  TodoEntity(
    this.id,
    this.label,
    this.createdAt,
  );
}
