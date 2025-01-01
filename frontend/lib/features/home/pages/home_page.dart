import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:frontend/features/home/pages/add_task_page.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TasksCubit>().getAllTasks(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        await context.read<TasksCubit>().syncTasks(user.user.token);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Tasks"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, AddTaskPage.route());
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Column(
          children: [
            DateSelector(
              selectedDate: selectedDate,
              onTap: (value) {
                setState(() {
                  selectedDate = value;
                });
              },
            ),
            BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is TasksLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is TasksError) {
                  return Center(child: Text(state.error));
                }
                if (state is GetTasksSuccess) {
                  final tasks = state.tasks
                      .where((elem) =>
                          DateFormat("d").format(selectedDate) ==
                              DateFormat("d").format(elem.dueAt) &&
                          selectedDate.month == elem.dueAt.month &&
                          selectedDate.year == elem.dueAt.year)
                      .toList();
                  return Expanded(
                    child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Row(
                            children: [
                              Expanded(
                                child: TaskCard(
                                    cardColor: task.color,
                                    headerText: task.title,
                                    descriptionText: task.description),
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: strengthenColor(task.color, 0.5)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(DateFormat.jm().format(task.dueAt),
                                    style: TextStyle(fontSize: 14)),
                              )
                            ],
                          );
                        }),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ));
  }
}
