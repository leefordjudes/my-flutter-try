import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_sqflite/data/data.dart';

final taskDatasourceProvider = Provider<TaskDatasource>((ref) {
  return TaskDatasource();
});
