import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/strings.dart' as strings;

/// Opens [url] in the platform's default browser, showing a snackbar if it cannot be opened.
Future<void> openExternalUrl(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.of(context);
  var launched = false;
  try {
    launched = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {
    launched = false;
  }
  if (!launched) {
    messenger.showSnackBar(SnackBar(content: Text(strings.cannotOpenUrl(url))));
  }
}
