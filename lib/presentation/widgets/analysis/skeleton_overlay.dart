import 'package:flutter/material.dart';
import '../../../data/models/skeleton.dart';
import '../../../data/models/joint.dart';
import '../../../core/utils/coordinate_utils.dart';
import 'skeleton_painter.dart';

/// Widget that displays the skeleton overlay on top of an image
class SkeletonOverlay extends StatefulWidget {
  final Skeleton skeleton;
  final Size imageSize;
  final Function(JointType, Offset) onJointMoved;
  final double zoomScale;
  final ImageProvider imageProvider;

  const SkeletonOverlay({
    super.key,
    required this.skeleton,
    required this.imageSize,
    required this.onJointMoved,
    required this.imageProvider,
    this.zoomScale = 1.0,
  });

  @override
  State<SkeletonOverlay> createState() => _SkeletonOverlayState();
}

class _SkeletonOverlayState extends State<SkeletonOverlay> {
  JointType? _activeJoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = Size(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Main gesture detector with skeleton painter
            GestureDetector(
              onPanStart: (details) => _handlePanStart(details, containerSize),
              onPanUpdate: (details) => _handlePanUpdate(details, containerSize),
              onPanEnd: (_) => _handlePanEnd(),
              child: CustomPaint(
                painter: SkeletonPainter(
                  skeleton: widget.skeleton,
                  imageSize: widget.imageSize,
                  containerSize: containerSize,
                  activeJoint: _activeJoint,
                  zoomScale: widget.zoomScale,
                ),
                child: Stack(
                  children: [
                    // Invisible hit areas for joints
                    for (final joint in widget.skeleton.visibleJoints)
                      _buildJointHitArea(joint, containerSize),
                  ],
                ),
              ),
            ),

            // Magnifier loupe when dragging - positioned over the node, not the finger
            if (_activeJoint != null)
              Builder(
                builder: (context) {
                  // Get the actual node position from the skeleton
                  final activeJointData = widget.skeleton.joints[_activeJoint];
                  if (activeJointData == null) return const SizedBox.shrink();

                  final nodeScreenPos = CoordinateUtils.normalizedToScreenWithFit(
                    activeJointData.position,
                    widget.imageSize,
                    containerSize,
                  );

                  return Positioned(
                    left: nodeScreenPos.dx - 50,
                    top: nodeScreenPos.dy - 120,
                    child: _buildMagnifier(containerSize, nodeScreenPos),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildMagnifier(Size containerSize, Offset nodeScreenPos) {
    const magnifierSize = 100.0;
    const magnificationScale = 2.5;

    // Calculate the image display area within the container (same logic as CoordinateUtils)
    final imageAspect = widget.imageSize.width / widget.imageSize.height;
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

    // Calculate the position within the image (0-1 normalized)
    final normalizedX = (nodeScreenPos.dx - offsetX) / displayWidth;
    final normalizedY = (nodeScreenPos.dy - offsetY) / displayHeight;

    // Calculate the offset for the magnified image
    // We want the node position to appear at the center of the magnifier
    final magnifiedImageWidth = displayWidth * magnificationScale;
    final magnifiedImageHeight = displayHeight * magnificationScale;

    // Position in the magnified image
    final posInMagnified = Offset(
      normalizedX * magnifiedImageWidth,
      normalizedY * magnifiedImageHeight,
    );

    // Offset to center this position in the magnifier
    final imageOffset = Offset(
      magnifierSize / 2 - posInMagnified.dx,
      magnifierSize / 2 - posInMagnified.dy,
    );

    return IgnorePointer(
      child: Container(
        width: magnifierSize,
        height: magnifierSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            children: [
              // Magnified image only (no skeleton)
              Positioned(
                left: imageOffset.dx,
                top: imageOffset.dy,
                width: magnifiedImageWidth,
                height: magnifiedImageHeight,
                child: Image(
                  image: widget.imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
              // Crosshair overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: _CrosshairPainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJointHitArea(Joint joint, Size containerSize) {
    final screenPos = CoordinateUtils.normalizedToScreenWithFit(
      joint.position,
      widget.imageSize,
      containerSize,
    );

    const hitAreaSize = 44.0; // Minimum touch target size

    return Positioned(
      left: screenPos.dx - hitAreaSize / 2,
      top: screenPos.dy - hitAreaSize / 2,
      width: hitAreaSize,
      height: hitAreaSize,
      child: GestureDetector(
        onTap: () {
          // Could show joint info or options
        },
        child: Container(
          // Transparent hit area
          color: Colors.transparent,
        ),
      ),
    );
  }

  void _handlePanStart(DragStartDetails details, Size containerSize) {
    final localPosition = details.localPosition;

    // Find if we're touching a joint
    for (final joint in widget.skeleton.visibleJoints) {
      final screenPos = CoordinateUtils.normalizedToScreenWithFit(
        joint.position,
        widget.imageSize,
        containerSize,
      );

      final distance = (screenPos - localPosition).distance;
      if (distance < 30) {
        // Touch threshold
        setState(() {
          _activeJoint = joint.type;
        });
        return;
      }
    }
  }

  void _handlePanUpdate(DragUpdateDetails details, Size containerSize) {
    if (_activeJoint == null) return;

    final newScreenPos = details.localPosition;

    final normalizedPos = CoordinateUtils.screenToNormalizedWithFit(
      newScreenPos,
      widget.imageSize,
      containerSize,
    );

    // Clamp to valid range
    final clampedPos = CoordinateUtils.clampNormalized(normalizedPos);

    widget.onJointMoved(_activeJoint!, clampedPos);
  }

  void _handlePanEnd() {
    setState(() {
      _activeJoint = null;
    });
  }
}

/// Paints a crosshair in the center of the magnifier
class _CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const crosshairSize = 12.0;

    // Horizontal line
    canvas.drawLine(
      Offset(centerX - crosshairSize, centerY),
      Offset(centerX + crosshairSize, centerY),
      paint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(centerX, centerY - crosshairSize),
      Offset(centerX, centerY + crosshairSize),
      paint,
    );

    // Small center dot
    final dotPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
