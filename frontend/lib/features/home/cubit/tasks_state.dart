part of 'tasks_cubit.dart';

sealed class TasksState {
  const TasksState();
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksError extends TasksState {
  final String error;
  TasksError(this.error);
}

class AddNewTaskSuccess extends TasksState {
  final TaskModel taskModel;
  const AddNewTaskSuccess(this.taskModel);
}

class GetTasksSuccess extends TasksState {
  final List<TaskModel> tasks;
  const GetTasksSuccess(this.tasks);
}
