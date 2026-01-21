import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/analysis/skeleton_overlay.dart';
import '../../data/models/skeleton.dart';
import '../../data/models/joint.dart';
import '../../data/models/saved_analysis.dart';
import '../../core/constants/joint_constants.dart';
import '../../data/repositories/pose_detection_repository.dart';
import '../../data/repositories/saves_repository.dart';

/// Provider for the current skeleton state
final skeletonProvider = StateProvider<Skeleton?>((ref) => null);

/// Provider for pose detection loading state
final isDetectingProvider = StateProvider<bool>((ref) => false);

/// Provider for skeleton visibility state
final skeletonVisibleProvider = StateProvider<bool>((ref) => true);

class AnalysisScreen extends ConsumerStatefulWidget {
  final String imagePath;
  final SavedAnalysis? savedAnalysis;

  const AnalysisScreen({
    super.key,
    required this.imagePath,
    this.savedAnalysis,
  });

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  final TransformationController _transformationController =
      TransformationController();
  late final PoseDetectionRepository _poseDetectionRepository;
  Size? _imageSize;
  double _currentScale = 1.0;
  SavedAnalysis? _currentSavedAnalysis;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _poseDetectionRepository = PoseDetectionRepository();
    _transformationController.addListener(_onTransformChanged);
    _currentSavedAnalysis = widget.savedAnalysis;
    _loadImageAndDetectPose();
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    _poseDetectionRepository.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale != _currentScale) {
      setState(() {
        _currentScale = scale;
      });
    }
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

    // If loading from a saved analysis, use the saved skeleton
    if (widget.savedAnalysis != null) {
      ref.read(skeletonProvider.notifier).state = widget.savedAnalysis!.skeleton;
    } else {
      // Detect pose for new analysis
      await _detectPose();
    }
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
    if (currentSkeleton == null || _imageSize == null) return;

    if (currentSkeleton.segmentLockEnabled) {
      // Disable lock
      ref.read(skeletonProvider.notifier).state =
          currentSkeleton.disableSegmentLock();
    } else {
      // Enable lock - capture current segment lengths with aspect ratio
      final aspectRatio = _imageSize!.width / _imageSize!.height;
      ref.read(skeletonProvider.notifier).state =
          currentSkeleton.captureSegmentLengths(aspectRatio);
    }
  }

  Future<void> _saveAnalysis() async {
    final currentSkeleton = ref.read(skeletonProvider);
    if (currentSkeleton == null) return;

    // If already saved, just update the skeleton
    if (_currentSavedAnalysis != null) {
      if (!mounted) return;
      setState(() => _isSaving = true);
      try {
        final repository = SavesRepository();
        final updated = _currentSavedAnalysis!.copyWith(skeleton: currentSkeleton);
        await repository.updateAnalysis(updated);
        if (!mounted) return;
        _currentSavedAnalysis = updated;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Analysis updated!')),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
      return;
    }

    // New save - ask for athlete name
    final athleteName = await _showSaveDialog();
    if (athleteName == null || athleteName.isEmpty || !mounted) return;

    setState(() => _isSaving = true);

    try {
      final repository = SavesRepository();
      final saved = await repository.saveAnalysis(
        athleteName: athleteName,
        sourceImagePath: widget.imagePath,
        skeleton: currentSkeleton,
      );
      if (!mounted) return;
      _currentSavedAnalysis = saved;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved analysis for $athleteName')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<String?> _showSaveDialog() async {
    String? result;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Save Analysis'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Athlete Name',
              hintText: 'Enter athlete name',
            ),
            textCapitalization: TextCapitalization.words,
            onSubmitted: (value) {
              result = value;
              Navigator.of(dialogContext).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                result = controller.text;
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final skeleton = ref.watch(skeletonProvider);
    final isDetecting = ref.watch(isDetectingProvider);
    final isSkeletonVisible = ref.watch(skeletonVisibleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze'),
        actions: [
          // Visibility toggle
          IconButton(
            icon: Icon(
              isSkeletonVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: skeleton != null && !isDetecting
                ? () => ref.read(skeletonVisibleProvider.notifier).state =
                    !isSkeletonVisible
                : null,
            tooltip: isSkeletonVisible ? 'Hide skeleton' : 'Show skeleton',
          ),
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
                        if (skeleton != null && !isDetecting && isSkeletonVisible)
                          Positioned.fill(
                            child: SkeletonOverlay(
                              skeleton: skeleton,
                              imageSize: _imageSize!,
                              onJointMoved: _onJointMoved,
                              zoomScale: _currentScale,
                              imageProvider: FileImage(File(widget.imagePath)),
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
                  onPressed: isDetecting || _isSaving ? null : _saveAnalysis,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Saving...' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
