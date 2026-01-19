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

  const SkeletonOverlay({
    super.key,
    required this.skeleton,
    required this.imageSize,
    required this.onJointMoved,
    this.zoomScale = 1.0,
  });

  @override
  State<SkeletonOverlay> createState() => _SkeletonOverlayState();
}

class _SkeletonOverlayState extends State<SkeletonOverlay> {
  JointType? _activeJoint;
  Offset? _currentDragPosition;

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

            // Magnifier loupe when dragging
            if (_activeJoint != null && _currentDragPosition != null)
              Positioned(
                left: _currentDragPosition!.dx - 50,
                top: _currentDragPosition!.dy - 120,
                child: _buildMagnifier(containerSize),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMagnifier(Size containerSize) {
    return IgnorePointer(
      child: Container(
        width: 100,
        height: 100,
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
              // Magnified content using RawMagnifier
              Positioned.fill(
                child: RawMagnifier(
                  magnificationScale: 2.5,
                  focalPointOffset: Offset(0, 70),
                  size: const Size(100, 100),
                  decoration: const MagnifierDecoration(
                    shape: CircleBorder(),
                  ),
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
          _currentDragPosition = localPosition;
        });
        return;
      }
    }
  }

  void _handlePanUpdate(DragUpdateDetails details, Size containerSize) {
    if (_activeJoint == null) return;

    final newScreenPos = details.localPosition;

    setState(() {
      _currentDragPosition = newScreenPos;
    });

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
      _currentDragPosition = null;
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
