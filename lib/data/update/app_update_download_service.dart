import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class AppUpdateDownloadService {
  final Dio _dio;

  AppUpdateDownloadService({Dio? dio}) : _dio = dio ?? Dio();

  Future<File> downloadApk({
    required String url,
    required String version,
    required void Function(double progress) onProgress,
  }) async {
    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/moftah-$version.apk');

    if (await file.exists()) {
      await file.delete();
    }

    await _dio.download(
      url,
      file.path,
      deleteOnError: true,
      options: Options(
        followRedirects: true,
        receiveTimeout: const Duration(minutes: 5),
      ),
      onReceiveProgress: (received, total) {
        if (total <= 0) return;

        onProgress((received / total).clamp(0.0, 1.0));
      },
    );

    if (!await file.exists()) {
      throw Exception('لم يتم العثور على ملف التحديث بعد التحميل.');
    }

    if (await file.length() == 0) {
      throw Exception('ملف التحديث فارغ.');
    }

    return file;
  }

  Future<OpenResult> installApk(File file) {
    return OpenFilex.open(
      file.path,
      type: 'application/vnd.android.package-archive',
    );
  }
}
