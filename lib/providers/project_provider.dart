import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../repositories/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository _repository = ProjectRepository();

  List<Project> _projects = [];
  Project? _selectedProject;
  List<TaskItem> _tasks = [];
  bool _isLoading = false;

  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  List<TaskItem> get tasks => _tasks;
  bool get isLoading => _isLoading;

  /// Loads all projects and defaults to the first one if available.
  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = await _repository.loadProjects();
      if (_projects.isNotEmpty && _selectedProject == null) {
        _selectedProject = _projects.first;
        await loadTasksForSelectedProject();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Switches the active project and loads its corresponding task file.
  Future<void> selectProject(String projectId) async {
    try {
      _selectedProject = _projects.firstWhere((p) => p.id == projectId);
      await loadTasksForSelectedProject();
      notifyListeners();
    } catch (_) {
      // Project not found fallback
    }
  }

  /// Loads tasks for the currently selected project.
  Future<void> loadTasksForSelectedProject() async {
    if (_selectedProject == null) {
      _tasks = [];
      return;
    }
    _tasks = await _repository.loadTasksForProject(_selectedProject!.id);
    notifyListeners();
  }

  /// Creates a new project and saves it to projects.json.
  Future<void> createProject(String name, String description) async {
    final newProject = Project(name: name, description: description);
    _projects.add(newProject);
    await _repository.saveProjects(_projects);

    if (_selectedProject == null) {
      _selectedProject = newProject;
      _tasks = [];
    }
    notifyListeners();
  }

  /// Adds a task to the active project and persists it.
  Future<void> addTask(TaskItem task) async {
    if (_selectedProject == null) return;
    _tasks.add(task);
    await _repository.saveTasksForProject(_selectedProject!.id, _tasks);
    notifyListeners();
  }

  /// Updates an existing task and persists changes.
  Future<void> updateTask(TaskItem updatedTask) async {
    if (_selectedProject == null) return;
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _repository.saveTasksForProject(_selectedProject!.id, _tasks);
      notifyListeners();
    }
  }

  /// Deletes a task from the active project.
  Future<void> deleteTask(String taskId) async {
    if (_selectedProject == null) return;
    _tasks.removeWhere((t) => t.id == taskId);
    await _repository.saveTasksForProject(_selectedProject!.id, _tasks);
    notifyListeners();
  }
}
