import 'dart:ui';

/// Utility class for coordinate transformations between different coordinate systems
class CoordinateUtils {
  CoordinateUtils._();

  /// Convert ML Kit coordinates (pixel values) to normalized (0-1) coordinates
  static Offset mlKitToNormalized(
    double x,
    double y,
    double imageWidth,
    double imageHeight,
  ) {
    return Offset(
      x / imageWidth,
      y / imageHeight,
    );
  }

  /// Convert normalized (0-1) coordinates to screen coordinates
  static Offset normalizedToScreen(
    Offset normalized,
    Size displaySize,
  ) {
    return Offset(
      normalized.dx * displaySize.width,
      normalized.dy * displaySize.height,
    );
  }

  /// Convert screen coordinates to normalized (0-1) coordinates
  static Offset screenToNormalized(
    Offset screenPos,
    Size displaySize,
  ) {
    return Offset(
      screenPos.dx / displaySize.width,
      screenPos.dy / displaySize.height,
    );
  }

  /// Convert normalized coordinates to screen coordinates, accounting for
  /// the image's aspect ratio fit within a container
  static Offset normalizedToScreenWithFit(
    Offset normalized,
    Size imageSize,
    Size containerSize,
  ) {
    final imageAspect = imageSize.width / imageSize.height;
    final containerAspect = containerSize.width / containerSize.height;

    double displayWidth, displayHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspect > containerAspect) {
      // Image is wider than container - fit to width
      displayWidth = containerSize.width;
      displayHeight = containerSize.width / imageAspect;
      offsetY = (containerSize.height - displayHeight) / 2;
    } else {
      // Image is taller than container - fit to height
      displayHeight = containerSize.height;
      displayWidth = containerSize.height * imageAspect;
      offsetX = (containerSize.width - displayWidth) / 2;
    }

    return Offset(
      offsetX + normalized.dx * displayWidth,
      offsetY + normalized.dy * displayHeight,
    );
  }

  /// Convert screen coordinates to normalized, accounting for image fit
  static Offset screenToNormalizedWithFit(
    Offset screenPos,
    Size imageSize,
    Size containerSize,
  ) {
    final imageAspect = imageSize.width / imageSize.height;
    final containerAspect = containerSize.width / containerSize.height;

    double displayWidth, displayHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspect > containerAspect) {
      displayWidth = containerSize.width;
      displayHeight = containerSize.width / imageAspect;
      offsetY = (containerSize.height - displayHeight) / 2;
    } else {
      displayHeight = containerSize.height;
      displayWidth = containerSize.height * imageAspect;
      offsetX = (containerSize.width - displayWidth) / 2;
    }

    return Offset(
      (screenPos.dx - offsetX) / displayWidth,
      (screenPos.dy - offsetY) / displayHeight,
    );
  }

  /// Clamp normalized coordinates to valid range (0-1)
  static Offset clampNormalized(Offset normalized) {
    return Offset(
      normalized.dx.clamp(0.0, 1.0),
      normalized.dy.clamp(0.0, 1.0),
    );
  }
}
