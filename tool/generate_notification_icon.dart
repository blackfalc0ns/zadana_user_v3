import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final logoFile = File('assets/images/notification_logo.png');
  final logoBytes = logoFile.readAsBytesSync();
  final logo = img.decodeImage(logoBytes)!;

  // Generate notification icons at required sizes with padding
  // Android notification icon sizes:
  // mdpi: 24x24, hdpi: 36x36, xhdpi: 48x48, xxhdpi: 72x72, xxxhdpi: 96x96
  final sizes = {
    'drawable-mdpi': 24,
    'drawable-hdpi': 36,
    'drawable-xhdpi': 48,
    'drawable-xxhdpi': 72,
    'drawable-xxxhdpi': 96,
  };

  for (final entry in sizes.entries) {
    final folder = entry.key;
    final size = entry.value;

    // Create transparent canvas
    final canvas = img.Image(width: size, height: size, numChannels: 4);
    img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));

    // Logo takes 92% of the icon with minimal padding
    final logoSize = (size * 0.92).round();

    // Resize logo
    final scaledLogo = img.copyResize(
      logo,
      width: logoSize,
      height: logoSize,
      maintainAspect: true,
      backgroundColor: img.ColorRgba8(0, 0, 0, 0),
    );

    // Convert to white-on-transparent (monochrome)
    // Any non-transparent pixel becomes white
    for (var y = 0; y < scaledLogo.height; y++) {
      for (var x = 0; x < scaledLogo.width; x++) {
        final pixel = scaledLogo.getPixel(x, y);
        final a = pixel.a.toInt();
        if (a > 20) {
          // Has content - make it white with original alpha
          scaledLogo.setPixelRgba(x, y, 255, 255, 255, a);
        } else {
          // Transparent - keep transparent
          scaledLogo.setPixelRgba(x, y, 0, 0, 0, 0);
        }
      }
    }

    // Center on canvas
    final offsetX = (size - scaledLogo.width) ~/ 2;
    final offsetY = (size - scaledLogo.height) ~/ 2;

    img.compositeImage(canvas, scaledLogo, dstX: offsetX, dstY: offsetY);

    // Save
    final outputPath = 'android/app/src/main/res/$folder/ic_stat_onesignal_default.png';
    final outputFile = File(outputPath);
    outputFile.createSync(recursive: true);
    outputFile.writeAsBytesSync(img.encodePng(canvas));
    // ignore: avoid_print
    print('Generated: $outputPath (${size}x$size)');
  }

  // ignore: avoid_print
  print('\nDone! All notification icons generated as white-on-transparent.');
}
