import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/saved_analysis.dart';
import '../models/skeleton.dart';

/// Repository for managing saved pose analyses
class SavesRepository {
  static const _savesFileName = 'saves.json';
  static const _imagesDir = 'images';

  final Uuid _uuid = const Uuid();

  /// Get the app's documents directory
  Future<Directory> _getAppDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return appDir;
  }

  /// Get the saves JSON file
  Future<File> _getSavesFile() async {
    final appDir = await _getAppDirectory();
    return File('${appDir.path}/$_savesFileName');
  }

  /// Get the images directory, creating it if needed
  Future<Directory> _getImagesDirectory() async {
    final appDir = await _getAppDirectory();
    final imagesDir = Directory('${appDir.path}/$_imagesDir');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  /// Load all saved analyses
  Future<List<SavedAnalysis>> getAllSaves() async {
    try {
      final file = await _getSavesFile();
      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => SavedAnalysis.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading saves: $e');
      return [];
    }
  }

  /// Save a new analysis
  Future<SavedAnalysis> saveAnalysis({
    required String athleteName,
    required String sourceImagePath,
    required Skeleton skeleton,
  }) async {
    final id = _uuid.v4();
    final imagesDir = await _getImagesDirectory();

    // Copy the source image to app storage
    final imageFile = File(sourceImagePath);
    final imagePath = '${imagesDir.path}/${id}_full.jpg';
    await imageFile.copy(imagePath);

    // Generate thumbnail
    final thumbnailPath = '${imagesDir.path}/${id}_thumb.jpg';
    await _generateThumbnail(sourceImagePath, thumbnailPath);

    final savedAnalysis = SavedAnalysis(
      id: id,
      athleteName: athleteName,
      imagePath: imagePath,
      thumbnailPath: thumbnailPath,
      skeleton: skeleton,
      savedAt: DateTime.now(),
    );

    // Add to saves list and persist
    final saves = await getAllSaves();
    saves.insert(0, savedAnalysis); // Add at beginning (most recent first)
    await _persistSaves(saves);

    return savedAnalysis;
  }

  /// Update an existing analysis (e.g., after editing skeleton or name)
  Future<void> updateAnalysis(SavedAnalysis analysis) async {
    final saves = await getAllSaves();
    final index = saves.indexWhere((s) => s.id == analysis.id);
    if (index != -1) {
      saves[index] = analysis;
      await _persistSaves(saves);
    }
  }

  /// Update just the athlete name for a save
  Future<SavedAnalysis?> updateAthleteName(String id, String newName) async {
    final saves = await getAllSaves();
    final index = saves.indexWhere((s) => s.id == id);
    if (index != -1) {
      final updated = saves[index].copyWith(athleteName: newName);
      saves[index] = updated;
      await _persistSaves(saves);
      return updated;
    }
    return null;
  }

  /// Delete a saved analysis
  Future<void> deleteAnalysis(String id) async {
    final saves = await getAllSaves();
    final analysis = saves.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Save not found'),
    );

    // Delete image files
    try {
      final imageFile = File(analysis.imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      final thumbFile = File(analysis.thumbnailPath);
      if (await thumbFile.exists()) {
        await thumbFile.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image files: $e');
    }

    // Remove from list and persist
    saves.removeWhere((s) => s.id == id);
    await _persistSaves(saves);
  }

  /// Persist saves list to JSON file
  Future<void> _persistSaves(List<SavedAnalysis> saves) async {
    final file = await _getSavesFile();
    final jsonList = saves.map((s) => s.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  /// Generate a thumbnail from the source image
  /// For now, just copy the original image as the thumbnail
  /// (proper resizing would require platform channels or a plugin)
  Future<void> _generateThumbnail(
      String sourcePath, String thumbnailPath) async {
    try {
      // Simply copy the source image as thumbnail
      // The UI will handle displaying it at the correct size
      await File(sourcePath).copy(thumbnailPath);
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
    }
  }
}
