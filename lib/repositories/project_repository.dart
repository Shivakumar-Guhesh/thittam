import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

import '../models/task_model.dart';

class ProjectRepository {
  Future<Directory> _getStorageDir() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final thittamDir = Directory('${appDocDir.path}/thittam_data');
    if (!await thittamDir.exists()) {
      await thittamDir.create(recursive: true);
    }
    return thittamDir;
  }

  Future<List<Project>> loadProjects() async {
    final dir = await _getStorageDir();
    final file = File('${dir.path}/projects.json');
    if (!await file.exists()) return [];

    try {
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((j) => Project.fromJson(j)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveProjects(List<Project> projects) async {
    final dir = await _getStorageDir();
    final file = File('${dir.path}/projects.json');
    final jsonList = projects.map((p) => p.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<List<TaskItem>> loadTasksForProject(String projectId) async {
    final dir = await _getStorageDir();
    final file = File('${dir.path}/tasks_$projectId.json');
    if (!await file.exists()) return [];

    try {
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((j) => TaskItem.fromJson(j)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTasksForProject(
    String projectId,
    List<TaskItem> tasks,
  ) async {
    final dir = await _getStorageDir();
    final file = File('${dir.path}/tasks_$projectId.json');
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}
