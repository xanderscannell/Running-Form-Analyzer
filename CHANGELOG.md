# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-01-21

### Added
- **Saved Analyses** - Save pose analyses with athlete names for later review
- **Saves Screen** - New screen accessible from home to view all saved analyses
- **Search** - Filter saved analyses by athlete name
- **Edit Athlete Name** - Rename athletes after saving
- **Delete Analyses** - Remove saved analyses with confirmation dialog
- **Persistent Storage** - Analyses saved to device storage (survives app restarts)
- **Thumbnail Previews** - Visual previews in saved analyses list

### Fixed
- Joint selection now picks the closest joint when multiple joints are near the touch point

---

## [0.2.1] - 2026-01-20

### Fixed
- Crop screen top bar no longer overlaps phone status bar (Android)
- Segment length scaling now works correctly with non-square images in locked mode
- Magnifying loupe now follows the dragged node instead of the finger position
- Magnifying loupe no longer shows skeleton nodes, only the image

---

## [0.2.0] - 2026-01-19

### Added
- Image cropping after camera/gallery selection
- Skeleton visibility toggle in app bar
- Magnifier loupe with crosshair when dragging joints
- Semi-transparent joint fills to see image underneath
- Zoom-independent node sizing (joints stay same screen size when zoomed)

## [0.1.0] - 2025-01-19

### Added
- Camera and gallery image selection
- Automatic pose detection using Google ML Kit
- Interactive skeleton overlay with 13 draggable joints
- Segment locking to maintain body proportions while adjusting pose angles
- Hip-centered hierarchy for natural skeleton manipulation
- Pinch-to-zoom for precise adjustments
- Re-detect pose button to reset adjustments
