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

  const SkeletonOverlay({
    super.key,
    required this.skeleton,
    required this.imageSize,
    required this.onJointMoved,
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

        return GestureDetector(
          onPanStart: (details) => _handlePanStart(details, containerSize),
          onPanUpdate: (details) => _handlePanUpdate(details, containerSize),
          onPanEnd: (_) => _handlePanEnd(),
          child: CustomPaint(
            painter: SkeletonPainter(
              skeleton: widget.skeleton,
              imageSize: widget.imageSize,
              containerSize: containerSize,
              activeJoint: _activeJoint,
            ),
            child: Stack(
              children: [
                // Invisible hit areas for joints
                for (final joint in widget.skeleton.visibleJoints)
                  _buildJointHitArea(joint, containerSize),
              ],
            ),
          ),
        );
      },
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
