import 'package:moftah/data/models/report/problem_attachment_model.dart';

class ProblemReportModel {
  final String vehicleId;
  final String vehicleName;
  final String brand;
  final int year;
  final List<String> symptoms;
  final String description;
  final List<ProblemAttachmentModel> attachments;
  final double latitude;
  final double longitude;
  final String locationLabel;

  const ProblemReportModel({
    required this.vehicleId,
    required this.vehicleName,
    required this.brand,
    required this.year,
    required this.symptoms,
    required this.description,
    required this.attachments,
    required this.latitude,
    required this.longitude,
    required this.locationLabel,
  });

  int get attachmentsCount => attachments.length;

  String get problemSummary {
    if (symptoms.isNotEmpty) return symptoms.join('، ');
    if (description.trim().isNotEmpty) return description.trim();
    return 'مشكلة غير محددة';
  }
}
