import 'package:floor/floor.dart';
import 'package:flutter_sensor/data/local/db/entities/todo_entity.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM todos')
  Stream<List<TodoEntity>> getTodoList();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTodo(TodoEntity todoEntity);
}
