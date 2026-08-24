class ObdDtcInfo {
  final String title;
  final String description;
  final String system;
  final List<String> possibleCauses;

  const ObdDtcInfo({
    required this.title,
    required this.description,
    required this.system,
    this.possibleCauses = const [],
  });
}
