class GitHubReleaseInfo {
  final String version;
  final String releaseNotes;
  final String? apkUrl;

  const GitHubReleaseInfo({
    required this.version,
    required this.releaseNotes,
    required this.apkUrl,
  });
}
