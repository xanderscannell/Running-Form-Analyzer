# Running Form Analyzer

An Android app for analyzing running form using ML-powered pose detection.

## Features

- **Camera & Gallery Support** - Take a photo or select from gallery
- **Automatic Pose Detection** - Uses Google ML Kit to detect body pose
- **Interactive Skeleton Overlay** - Drag joints to fine-tune positions
- **Segment Locking** - Lock body proportions while adjusting pose angles
- **Pinch to Zoom** - Zoom in for precise adjustments

## How It Works

1. Take or select a photo of someone running
2. The app automatically detects the pose and overlays a stick figure
3. Drag any joint to adjust its position
4. Use the lock icon to maintain body segment lengths while rotating joints
5. Use the refresh icon to re-detect the original pose

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Google ML Kit** - On-device pose detection (33 landmarks)
- **Riverpod** - State management
- **Freezed** - Immutable data models

## Requirements

- Android device (ML Kit pose detection requires Android/iOS)
- Camera permission (for taking photos)
- Storage permission (for gallery access)

## Development

```bash
# Install dependencies
flutter pub get

# Generate freezed models
dart run build_runner build

# Run on connected device
flutter run
```

## Building

```bash
# Build release APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```
