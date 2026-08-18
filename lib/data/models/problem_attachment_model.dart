enum ProblemAttachmentType { image, video }

class ProblemAttachmentModel {
  final String path;
  final ProblemAttachmentType type;

  const ProblemAttachmentModel({
    required this.path,
    required this.type,
  });
}
