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

  SkeletonPainter({
    required this.skeleton,
    required this.imageSize,
    required this.containerSize,
    this.activeJoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connections first (so joints appear on top)
    _drawConnections(canvas);

    // Draw joints
    _drawJoints(canvas);
  }

  void _drawConnections(Canvas canvas) {
    final linePaint = Paint()
      ..color = AppColors.connectionLine
      ..strokeWidth = 4.0
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
    const jointRadius = 10.0;
    const activeJointRadius = 14.0;

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
        ..strokeWidth = 3.0;
      canvas.drawCircle(screenPos, radius, borderPaint);

      // Draw filled circle
      final fillPaint = Paint()
        ..color = jointColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(screenPos, radius - 1.5, fillPaint);

      // Draw shadow/glow for active joint
      if (isActive) {
        final glowPaint = Paint()
          ..color = jointColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(screenPos, radius + 8, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(SkeletonPainter oldDelegate) {
    return oldDelegate.skeleton != skeleton ||
        oldDelegate.activeJoint != activeJoint ||
        oldDelegate.containerSize != containerSize;
  }
}
