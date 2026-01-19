import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/analysis/skeleton_overlay.dart';
import '../../data/models/skeleton.dart';
import '../../data/models/joint.dart';
import '../../core/constants/joint_constants.dart';
import '../../data/repositories/pose_detection_repository.dart';

/// Provider for the current skeleton state
final skeletonProvider = StateProvider<Skeleton?>((ref) => null);

/// Provider for pose detection loading state
final isDetectingProvider = StateProvider<bool>((ref) => false);

class AnalysisScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const AnalysisScreen({
    super.key,
    required this.imagePath,
  });

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  final TransformationController _transformationController =
      TransformationController();
  late final PoseDetectionRepository _poseDetectionRepository;
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    _poseDetectionRepository = PoseDetectionRepository();
    _loadImageAndDetectPose();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _poseDetectionRepository.dispose();
    super.dispose();
  }

  Future<void> _loadImageAndDetectPose() async {
    // Get image dimensions
    final imageFile = File(widget.imagePath);
    final decodedImage = await decodeImageFromList(await imageFile.readAsBytes());
    setState(() {
      _imageSize = Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      );
    });

    // Detect pose
    await _detectPose();
  }

  Future<void> _detectPose() async {
    ref.read(isDetectingProvider.notifier).state = true;

    try {
      final skeleton =
          await _poseDetectionRepository.detectPose(widget.imagePath);

      if (skeleton != null) {
        // Apply default visibility settings
        final configuredSkeleton =
            skeleton.applyVisibilityConfig(JointConstants.defaultVisibility);
        ref.read(skeletonProvider.notifier).state = configuredSkeleton;
      } else {
        // Create empty skeleton if detection failed
        ref.read(skeletonProvider.notifier).state = Skeleton.empty(
          JointConstants.defaultConnections,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No pose detected. Try a different image.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error detecting pose: $e')),
        );
      }
    } finally {
      ref.read(isDetectingProvider.notifier).state = false;
    }
  }

  void _resetAdjustments() {
    _detectPose();
    _transformationController.value = Matrix4.identity();
  }

  void _onJointMoved(JointType jointType, Offset newPosition) {
    final currentSkeleton = ref.read(skeletonProvider);
    if (currentSkeleton != null) {
      // Use locked update if segment lock is enabled
      if (currentSkeleton.segmentLockEnabled) {
        ref.read(skeletonProvider.notifier).state =
            currentSkeleton.updateJointPositionLocked(jointType, newPosition);
      } else {
        ref.read(skeletonProvider.notifier).state =
            currentSkeleton.updateJointPosition(jointType, newPosition);
      }
    }
  }

  void _toggleSegmentLock() {
    final currentSkeleton = ref.read(skeletonProvider);
    if (currentSkeleton == null) return;

    if (currentSkeleton.segmentLockEnabled) {
      // Disable lock
      ref.read(skeletonProvider.notifier).state =
          currentSkeleton.disableSegmentLock();
    } else {
      // Enable lock - capture current segment lengths
      ref.read(skeletonProvider.notifier).state =
          currentSkeleton.captureSegmentLengths();
    }
  }

  @override
  Widget build(BuildContext context) {
    final skeleton = ref.watch(skeletonProvider);
    final isDetecting = ref.watch(isDetectingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze'),
        actions: [
          // Segment lock toggle
          IconButton(
            icon: Icon(
              skeleton?.segmentLockEnabled == true
                  ? Icons.lock
                  : Icons.lock_open,
            ),
            onPressed: skeleton != null && !isDetecting ? _toggleSegmentLock : null,
            tooltip: skeleton?.segmentLockEnabled == true
                ? 'Unlock segment lengths'
                : 'Lock segment lengths',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isDetecting ? null : _resetAdjustments,
            tooltip: 'Re-detect pose',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          if (_imageSize != null)
            InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Base image
                        Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.contain,
                        ),

                        // Skeleton overlay
                        if (skeleton != null && !isDetecting)
                          Positioned.fill(
                            child: SkeletonOverlay(
                              skeleton: skeleton,
                              imageSize: _imageSize!,
                              onJointMoved: _onJointMoved,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          // Loading overlay
          if (isDetecting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Detecting pose...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isDetecting ? null : _resetAdjustments,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Implement save/export
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Save feature coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
