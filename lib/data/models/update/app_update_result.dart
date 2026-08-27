class AppUpdateResult {
  final bool updateAvailable;

  final String? currentVersion;
  final String? latestVersion;

  final String? releaseNotes;
  final String? apkUrl;

  final String? error;

  const AppUpdateResult({
    required this.updateAvailable,
    this.currentVersion,
    this.latestVersion,
    this.releaseNotes,
    this.apkUrl,
    this.error,
  });
}
