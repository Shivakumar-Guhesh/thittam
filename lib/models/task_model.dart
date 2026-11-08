import 'dart:convert';

import 'package:uuid/uuid.dart';

enum ItemType { epic, feature, story, subtask }

enum ItemStatus { todo, inProgress, blocked, done }

enum ItemPriority { low, medium, high, urgent }

class TaskItem {
  final String id;
  final String projectId;
  final String? parentId; // Links to parent Epic/Feature/Story
  final ItemType type;

  String title;
  String description;
  ItemStatus status;
  ItemPriority priority;
  int storyPoints;
  DateTime? dueDate;
  List<String> tags;

  final DateTime createdAt;
  DateTime updatedAt;

  TaskItem({
    String? id,
    required this.projectId,
    this.parentId,
    required this.type,
    required this.title,
    this.description = '',
    this.status = ItemStatus.todo,
    this.priority = ItemPriority.medium,
    this.storyPoints = 0,
    this.dueDate,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       tags = tags ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'parentId': parentId,
    'type': type.name,
    'title': title,
    'description': description,
    'status': status.name,
    'priority': priority.name,
    'storyPoints': storyPoints,
    'dueDate': dueDate?.toIso8601String(),
    'tags': tags,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
    id: json['id'],
    projectId: json['projectId'],
    parentId: json['parentId'],
    type: ItemType.values.byName(json['type']),
    title: json['title'],
    description: json['description'] ?? '',
    status: ItemStatus.values.byName(json['status']),
    priority: ItemPriority.values.byName(json['priority']),
    storyPoints: json['storyPoints'] ?? 0,
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    tags: List<String>.from(json['tags'] ?? []),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  TaskItem copyWith({
    String? title,
    String? description,
    ItemStatus? status,
    ItemPriority? priority,
    int? storyPoints,
    DateTime? dueDate,
    List<String>? tags,
    String? parentId,
  }) {
    return TaskItem(
      id: id,
      projectId: projectId,
      parentId: parentId ?? this.parentId,
      type: type,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      storyPoints: storyPoints ?? this.storyPoints,
      dueDate: dueDate ?? this.dueDate,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class Project {
  final String id;
  String name;
  String description;
  final DateTime createdAt;

  Project({
    String? id,
    required this.name,
    this.description = '',
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',
    createdAt: DateTime.parse(json['createdAt']),
  );
}
