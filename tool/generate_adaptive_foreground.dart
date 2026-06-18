import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final logoFile = File('assets/images/logo_dark.png');
  final logoBytes = logoFile.readAsBytesSync();
  final logo = img.decodeImage(logoBytes)!;

  // Create a 1024x1024 transparent canvas with logo at 65%
  const canvasSize = 1024;
  const logoTargetSize = 665; // ~65% of canvas

  // Create transparent canvas
  final canvas = img.Image(width: canvasSize, height: canvasSize, numChannels: 4);
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));

  // Resize logo maintaining aspect ratio
  final scaledLogo = img.copyResize(
    logo,
    width: logoTargetSize,
    height: logoTargetSize,
    maintainAspect: true,
    backgroundColor: img.ColorRgba8(0, 0, 0, 0),
  );

  // Center it on canvas
  final offsetX = (canvasSize - scaledLogo.width) ~/ 2;
  final offsetY = (canvasSize - scaledLogo.height) ~/ 2;

  img.compositeImage(canvas, scaledLogo, dstX: offsetX, dstY: offsetY);

  // Save
  final outputFile = File('assets/images/logo_dark_padded.png');
  outputFile.writeAsBytesSync(img.encodePng(canvas));
  // ignore: avoid_print
  print('Generated padded logo: ${outputFile.path}');
}
