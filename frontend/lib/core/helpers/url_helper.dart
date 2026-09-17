// frontend/lib/core/utils/url_helper.dart
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<void> launchExternalUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir la URL: $urlString');
    }
  }
}
