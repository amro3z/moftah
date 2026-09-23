enum RepairStageStatus { completed, current, upcoming }

class RepairStageItem {
  final String title;
  final String? description;
  final String? time;
  final RepairStageStatus status;
  final String? actionText;
  final String? onActionPath;

  const RepairStageItem({
    required this.title,
    required this.status,
    this.description,
    this.time,
    this.actionText,
    this.onActionPath,
  });

  RepairStageItem copyWith({
    String? title,
    String? description,
    String? time,
    RepairStageStatus? status,
    String? actionText,
    String? onActionPath,
  }) {
    return RepairStageItem(
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      status: status ?? this.status,
      actionText: actionText ?? this.actionText,
      onActionPath: onActionPath ?? this.onActionPath,
    );
  }
}
