import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moftah/data/models/github_release_info.dart';

class GitHubUpdateService {
  static const String _owner = 'amro3z';
  static const String _repo = 'moftah';

  static const String _latestReleaseUrl =
      'https://api.github.com/repos/$_owner/$_repo/releases/latest';

  Future<GitHubReleaseInfo?> getLatestRelease() async {
    final response = await http.get(
      Uri.parse(_latestReleaseUrl),
      headers: const {'Accept': 'application/vnd.github+json'},
    );

    if (response.statusCode == 404) {
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load latest release: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final tagName = data['tag_name']?.toString() ?? '';
    final releaseNotes = data['body']?.toString() ?? '';

    final assets = data['assets'] as List<dynamic>? ?? const [];

    String? apkUrl;

    for (final asset in assets) {
      if (asset is! Map<String, dynamic>) continue;

      final name = asset['name']?.toString().toLowerCase() ?? '';

      if (name.endsWith('.apk')) {
        apkUrl = asset['browser_download_url']?.toString();
        break;
      }
    }

    return GitHubReleaseInfo(
      version: tagName.replaceFirst('v', ''),
      releaseNotes: releaseNotes,
      apkUrl: apkUrl,
    );
  }
}


