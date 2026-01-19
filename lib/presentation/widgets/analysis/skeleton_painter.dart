import 'package:flutter/material.dart';
import '../../../data/models/skeleton.dart';
import '../../../data/models/joint.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/coordinate_utils.dart';

/// CustomPainter that draws the skeleton (joints and connections) on canvas
class SkeletonPainter extends CustomPainter {
  final Skeleton skeleton;
  final Size imageSize;
  final Size containerSize;
  final JointType? activeJoint;
  final double zoomScale;

  SkeletonPainter({
    required this.skeleton,
    required this.imageSize,
    required this.containerSize,
    this.activeJoint,
    this.zoomScale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connections first (so joints appear on top)
    _drawConnections(canvas);

    // Draw joints
    _drawJoints(canvas);
  }

  void _drawConnections(Canvas canvas) {
    // Apply inverse zoom to maintain constant visual size
    final inverseScale = 1.0 / zoomScale;

    final linePaint = Paint()
      ..color = AppColors.connectionLine.withValues(alpha: 0.8)
      ..strokeWidth = 4.0 * inverseScale
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final connection in skeleton.visibleConnections) {
      final fromJoint = skeleton.joints[connection.from];
      final toJoint = skeleton.joints[connection.to];

      if (fromJoint != null && toJoint != null) {
        final fromPos = CoordinateUtils.normalizedToScreenWithFit(
          fromJoint.position,
          imageSize,
          containerSize,
        );
        final toPos = CoordinateUtils.normalizedToScreenWithFit(
          toJoint.position,
          imageSize,
          containerSize,
        );

        canvas.drawLine(fromPos, toPos, linePaint);
      }
    }
  }

  void _drawJoints(Canvas canvas) {
    // Apply inverse zoom to maintain constant visual size
    final inverseScale = 1.0 / zoomScale;
    final jointRadius = 10.0 * inverseScale;
    final activeJointRadius = 14.0 * inverseScale;
    final borderWidth = 3.0 * inverseScale;
    final glowRadius = 8.0 * inverseScale;

    for (final joint in skeleton.visibleJoints) {
      final screenPos = CoordinateUtils.normalizedToScreenWithFit(
        joint.position,
        imageSize,
        containerSize,
      );

      final isActive = joint.type == activeJoint;
      final radius = isActive ? activeJointRadius : jointRadius;

      // Determine joint color based on state
      Color jointColor;
      if (isActive) {
        jointColor = AppColors.jointSelected;
      } else if (joint.isManuallyAdjusted) {
        jointColor = AppColors.jointManuallyAdjusted;
      } else {
        jointColor = AppColors.jointDefault;
      }

      // Draw outer circle (border)
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawCircle(screenPos, radius, borderPaint);

      // Draw filled circle (semi-transparent to see image underneath)
      final fillPaint = Paint()
        ..color = jointColor.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(screenPos, radius - (1.5 * inverseScale), fillPaint);

      // Draw shadow/glow for active joint
      if (isActive) {
        final glowPaint = Paint()
          ..color = jointColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(screenPos, radius + glowRadius, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(SkeletonPainter oldDelegate) {
    return oldDelegate.skeleton != skeleton ||
        oldDelegate.activeJoint != activeJoint ||
        oldDelegate.containerSize != containerSize ||
        oldDelegate.zoomScale != zoomScale;
  }
}
