import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_sqflite/utils/utils.dart';

final categoryProvider = StateProvider.autoDispose<TaskCategories>((ref) {
  return TaskCategories.others;
});
