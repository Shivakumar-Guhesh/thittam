import 'task_model.dart';

class MetricRollup {
  final int totalItems;
  final int completedItems;
  final int totalStoryPoints;
  final int completedStoryPoints;
  final double completionPercentage;
  final Map<ItemStatus, int> statusCounts;

  MetricRollup({
    required this.totalItems,
    required this.completedItems,
    required this.totalStoryPoints,
    required this.completedStoryPoints,
    required this.completionPercentage,
    required this.statusCounts,
  });
}

extension TaskHierarchyExtension on List<TaskItem> {
  /// Recursively retrieves all descendant tasks for a given parent ID.
  List<TaskItem> getDescendants(String parentId) {
    final children = where((t) => t.parentId == parentId).toList();
    final descendants = <TaskItem>[...children];
    for (final child in children) {
      descendants.addAll(getDescendants(child.id));
    }
    return descendants;
  }

  /// Calculates aggregate metric rollups for any given task item (Epic, Feature, or Story).
  MetricRollup calculateRollup(String taskId) {
    final targetTask = firstWhere(
      (t) => t.id == taskId,
      orElse: () => throw Exception('Task with ID $taskId not found'),
    );

    final descendants = getDescendants(taskId);

    // Include the target task itself or treat it as a container depending on convention.
    // Here we compute rollups based strictly on its descendant hierarchy tree.
    if (descendants.isEmpty) {
      final isDone = targetTask.status == ItemStatus.done;
      return MetricRollup(
        totalItems: 1,
        completedItems: isDone ? 1 : 0,
        totalStoryPoints: targetTask.storyPoints,
        completedStoryPoints: isDone ? targetTask.storyPoints : 0,
        completionPercentage: isDone ? 100.0 : 0.0,
        statusCounts: {targetTask.status: 1},
      );
    }

    final allItems = [targetTask, ...descendants];
    int totalItems = allItems.length;
    int completedItems = allItems
        .where((t) => t.status == ItemStatus.done)
        .length;

    int totalPoints = allItems.fold(0, (sum, t) => sum + t.storyPoints);
    int completedPoints = allItems
        .where((t) => t.status == ItemStatus.done)
        .fold(0, (sum, t) => sum + t.storyPoints);

    double percentage = totalItems > 0
        ? (completedItems / totalItems) * 100
        : 0.0;

    final statusCounts = <ItemStatus, int>{
      ItemStatus.todo: 0,
      ItemStatus.inProgress: 0,
      ItemStatus.blocked: 0,
      ItemStatus.done: 0,
    };

    for (final task in allItems) {
      statusCounts[task.status] = (statusCounts[task.status] ?? 0) + 1;
    }

    return MetricRollup(
      totalItems: totalItems,
      completedItems: completedItems,
      totalStoryPoints: totalPoints,
      completedStoryPoints: completedPoints,
      completionPercentage: percentage,
      statusCounts: statusCounts,
    );
  }
}
