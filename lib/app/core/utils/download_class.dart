import 'dart:developer';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadClass {
  @pragma('vm:entry-point')
  static void callback(String id, int status, int progress) {
    log("Download status: $status");
    log("Download progress: $progress");
  }
}
