import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_sqflite/data/data.dart';
import 'package:todo_riverpod_sqflite/providers/providers.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});
