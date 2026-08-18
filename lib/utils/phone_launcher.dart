import 'package:url_launcher/url_launcher.dart';

class PhoneLauncher {
  PhoneLauncher._();

  static Future<bool> call(String phone) async {
    final number = phone.trim();
    if (number.isEmpty) return false;

    return launchUrl(
      Uri(scheme: 'tel', path: number),
      mode: LaunchMode.externalApplication,
    );
  }
}
