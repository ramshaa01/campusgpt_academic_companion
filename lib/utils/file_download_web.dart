import 'dart:html' as html;

void downloadTextFile(String filename, String content) {
  final bytes = html.Blob([content]);
  final url = html.Url.createObjectUrlFromBlob(bytes);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}
