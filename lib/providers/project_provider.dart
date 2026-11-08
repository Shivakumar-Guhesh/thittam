import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';
import '../repositories/project_repository.dart';

class ProjectState {
  final List<Project> projects;
  final Project? selectedProject;
  final List<TaskItem> tasks;
  final bool isLoading;

  const ProjectState({
    this.projects = const [],
    this.selectedProject,
    this.tasks = const [],
    this.isLoading = false,
  });

  ProjectState copyWith({
    List<Project>? projects,
    Project? selectedProject,
    List<TaskItem>? tasks,
    bool? isLoading,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProjectNotifier extends Notifier<ProjectState> {
  final ProjectRepository _repository = ProjectRepository();

  @override
  ProjectState build() {
    loadProjects();
    return const ProjectState(isLoading: true);
  }

  Future<void> loadProjects() async {
    state = state.copyWith(isLoading: true);
    try {
      final projects = await _repository.loadProjects();
      Project? selected = state.selectedProject;
      List<TaskItem> tasks = state.tasks;

      if (projects.isNotEmpty && selected == null) {
        selected = projects.first;
        tasks = await _repository.loadTasksForProject(selected.id);
      }

      state = state.copyWith(
        projects: projects,
        selectedProject: selected,
        tasks: tasks,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> selectProject(String projectId) async {
    try {
      final selected = state.projects.firstWhere((p) => p.id == projectId);
      final tasks = await _repository.loadTasksForProject(selected.id);
      state = state.copyWith(selectedProject: selected, tasks: tasks);
    } catch (_) {}
  }

  Future<void> createProject(String name, String description) async {
    final newProject = Project(name: name, description: description);
    final updatedProjects = [...state.projects, newProject];
    await _repository.saveProjects(updatedProjects);

    Project? selected = state.selectedProject;
    List<TaskItem> tasks = state.tasks;

    if (selected == null) {
      selected = newProject;
      tasks = [];
    }

    state = state.copyWith(
      projects: updatedProjects,
      selectedProject: selected,
      tasks: tasks,
    );
  }

  Future<void> addTask(TaskItem task) async {
    if (state.selectedProject == null) return;
    final updatedTasks = [...state.tasks, task];
    await _repository.saveTasksForProject(
      state.selectedProject!.id,
      updatedTasks,
    );
    state = state.copyWith(tasks: updatedTasks);
  }

  Future<void> updateTask(TaskItem updatedTask) async {
    if (state.selectedProject == null) return;
    final updatedTasks = state.tasks
        .map((t) => t.id == updatedTask.id ? updatedTask : t)
        .toList();
    await _repository.saveTasksForProject(
      state.selectedProject!.id,
      updatedTasks,
    );
    state = state.copyWith(tasks: updatedTasks);
  }

  Future<void> deleteTask(String taskId) async {
    if (state.selectedProject == null) return;
    final updatedTasks = state.tasks.where((t) => t.id != taskId).toList();
    await _repository.saveTasksForProject(
      state.selectedProject!.id,
      updatedTasks,
    );
    state = state.copyWith(tasks: updatedTasks);
  }
}

final projectProvider = NotifierProvider<ProjectNotifier, ProjectState>(() {
  return ProjectNotifier();
});
