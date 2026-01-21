import 'package:freezed_annotation/freezed_annotation.dart';
import 'skeleton.dart';

part 'saved_analysis.freezed.dart';
part 'saved_analysis.g.dart';

/// Represents a saved pose analysis with metadata
@freezed
class SavedAnalysis with _$SavedAnalysis {
  const factory SavedAnalysis({
    /// Unique identifier (UUID)
    required String id,
    /// Name of the athlete
    required String athleteName,
    /// Path to the saved cropped image
    required String imagePath,
    /// Path to the thumbnail image
    required String thumbnailPath,
    /// The skeleton pose data
    required Skeleton skeleton,
    /// When the analysis was saved
    required DateTime savedAt,
  }) = _SavedAnalysis;

  factory SavedAnalysis.fromJson(Map<String, dynamic> json) =>
      _$SavedAnalysisFromJson(json);
}
