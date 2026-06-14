import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../common/constants.dart';
import '../common/strings.dart' as strings;
import '../utils/color_utils.dart' as color_utils;
import '../utils/share_image.dart';

/// Renders the current color as a square card and opens the platform share sheet
/// with it and a short caption. Shows a snackbar if sharing fails.
///
/// [countText] is the count already formatted in the user's numeral system, so the
/// image matches the Taps screen.
Future<void> shareJourney(
  BuildContext context, {
  required int count,
  required String countText,
  required Color fill,
  required Color contrast,
  String? colorName,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final origin = _sharePositionOrigin(context);
  try {
    final image = await renderColorCard(
      fill: fill,
      contrast: contrast,
      countText: countText,
      colorName: colorName,
      url: appUrl,
    );
    await SharePlus.instance.share(
      ShareParams(
        text: strings.shareJourneyCaption(
          hex: color_utils.hexWithHash(count),
          name: colorName,
          url: appUrl,
        ),
        files: [XFile.fromData(image, mimeType: 'image/png')],
        fileNameOverrides: ['16MillionTaps-$count.png'],
        sharePositionOrigin: origin,
      ),
    );
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(strings.shareFailed)));
  }
}

/// The anchor rect the iPad share popover points at; harmless (and null-safe) elsewhere.
Rect? _sharePositionOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}
