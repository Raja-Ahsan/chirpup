import 'package:url_launcher/url_launcher.dart';

class UrlOpenHelper {
  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: WebViewConfiguration(),
        browserConfiguration: BrowserConfiguration(),
      );

      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}