// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:todo_riverpod_sqflite/utils/utils.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String note;
  final String time;
  final String date;
  final TaskCategories category;
  final bool isCompleted;
  const Task({
    this.id,
    required this.title,
    required this.note,
    required this.time,
    required this.date,
    required this.category,
    required this.isCompleted,
  });

  @override
  List<Object?> get props {
    return [
      id!,
      title,
      note,
      time,
      date,
      category,
      isCompleted,
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      TaskKeys.id: id,
      TaskKeys.title: title,
      TaskKeys.note: note,
      TaskKeys.time: time,
      TaskKeys.date: date,
      TaskKeys.category: category.name,
      TaskKeys.isCompleted: isCompleted ? 1 : 0,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json[TaskKeys.id],
      title: json[TaskKeys.title],
      note: json[TaskKeys.note],
      time: json[TaskKeys.time],
      date: json[TaskKeys.date],
      category: TaskCategories.stringToTaskCategory(json[TaskKeys.category]),
      isCompleted: json[TaskKeys.isCompleted] == 1 ? true : false,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? note,
    String? time,
    String? date,
    TaskCategories? category,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      time: time ?? this.time,
      date: date ?? this.date,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
