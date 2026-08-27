import 'package:moftah/data/models/report/problem_report_model.dart';

class ReportWorkshopsRouteArguments {
  final ProblemReportModel report;
  final double userLatitude;
  final double userLongitude;

  const ReportWorkshopsRouteArguments({
    required this.report,
    required this.userLatitude,
    required this.userLongitude,
  });
}
