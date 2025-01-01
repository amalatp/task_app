import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/repository/task_local_repository.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createTask(
      {required String title,
      required String description,
      required Color hexColor,
      required String token,
      required String uid,
      required DateTime dueAt}) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
          title: title,
          description: description,
          hexColor: rgbToHex(hexColor),
          token: token,
          dueAt: dueAt,
          uid: uid);

      await taskLocalRepository.insertTask(taskModel);

      emit(AddNewTaskSuccess(taskModel));
    } catch (e) {
      log("error from cbit $e");
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getAllTasks({
    required String token,
  }) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(token: token);

      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> syncTasks(String token) async {
    final unsyncedTasks = await taskLocalRepository.getUnsyncedTasks();
    if (unsyncedTasks.isEmpty) {
      log("unsyncedTasks.isEmpty");
      return;
    }
    final isSynced = await taskRemoteRepository.syncTasks(
        token: token, tasks: unsyncedTasks);
    if (isSynced) {
      for (final task in unsyncedTasks) {
        taskLocalRepository.updateRowVlaue(task.id, 1);
      }
    }
  }
}
