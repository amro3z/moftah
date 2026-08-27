import 'package:moftah/data/models/update/app_update_result.dart';
import 'package:moftah/data/update/app_version_service.dart';
import 'package:moftah/data/update/github_update_service.dart';
import 'package:pub_semver/pub_semver.dart';

class AppUpdateRepository {
  final AppVersionService versionService;
  final GitHubUpdateService githubService;

  AppUpdateRepository({
    AppVersionService? versionService,
    GitHubUpdateService? githubService,
  }) : versionService = versionService ?? const AppVersionService(),
       githubService = githubService ?? GitHubUpdateService();

  Future<AppUpdateResult> checkForUpdate() async {
    try {
      final currentVersionText = await versionService.getCurrentVersion();

      final latestRelease = await githubService.getLatestRelease();

      if (latestRelease == null) {
        return AppUpdateResult(
          currentVersion: currentVersionText,
          updateAvailable: false,
        );
      }

      final currentVersion = Version.parse(_cleanVersion(currentVersionText));

      final latestVersion = Version.parse(_cleanVersion(latestRelease.version));

      final hasUpdate = latestVersion > currentVersion;

      return AppUpdateResult(
        currentVersion: currentVersionText,
        latestVersion: latestRelease.version,
        updateAvailable: hasUpdate,
        releaseNotes: latestRelease.releaseNotes,
        apkUrl: latestRelease.apkUrl,
      );
    } catch (error) {
      return AppUpdateResult(updateAvailable: false, error: error.toString());
    }
  }

  String _cleanVersion(String version) {
    return version.trim().replaceFirst(RegExp(r'^[vV]'), '');
  }
}
