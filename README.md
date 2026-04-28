# Word Bulldog 🐕

Personalized English vocabulary learning app with adaptive difficulty, optimized for POCO F3.

## Features

- **Smart Learning**: Adaptive difficulty algorithm based on spaced repetition and forgetting curve
- **Semantic Search**: Find words by theme using keyword-based search
- **Offline First**: Full functionality without internet connection
- **Progress Tracking**: Detailed statistics and learning analytics
- **Beautiful UI**: Smooth animations optimized for 120Hz AMOLED display

## Target Device

- **Model**: POCO F3 (M2012K11AG)
- **OS**: Android 13 / HyperOS 1.0.6.0
- **Screen**: 120Hz AMOLED
- **CPU**: Snapdragon 870

## Installation

### From APK
1. Download the latest APK from releases
2. Enable "Install from Unknown Sources" on your device
3. Install the APK
4. Launch Word Bulldog!

### Build from Source

```bash
# Clone the repository
git clone https://github.com/yourusername/word-bulldog.git
cd word-bulldog

# Install dependencies
flutter pub get

# Generate code (Isar, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Build APK for POCO F3 (ARM64)
flutter build apk --release --target-platform android-arm64

# Or build universal APK
flutter build apk --release

# Build App Bundle for Google Play
flutter build appbundle --release
```

The APK will be located at:
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (for POCO F3)
- `build/app/outputs/flutter-apk/app-release.apk` (universal)

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core utilities and constants
│   ├── constants/                     # App-wide constants
│   ├── utils/                         # Utility functions
│   ├── database/                      # Database models and helpers
│   └── network/                       # Network services
├── features/                          # Feature modules
│   ├── onboarding/                    # First-time user onboarding
│   ├── welcome/                       # Welcome screen
│   ├── keyword_input/                 # Keyword search input
│   ├── training/                      # Training session screens
│   └── progress/                      # Progress tracking
├── domain/                            # Business logic
│   ├── entities/                      # Domain entities
│   ├── repositories/                  # Data repositories
│   └── services/                      # Domain services
└── presentation/                      # UI components
    ├── widgets/                       # Reusable widgets
    ├── themes/                        # App theming
    └── animations/                    # Custom animations
```

## Technologies

- **Flutter** 3.19.0 - Cross-platform framework
- **Hive** - Local NoSQL database
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Dio** - HTTP client
- **TFLite** - On-device ML for semantic search

## Performance Targets

| Metric | Target |
|--------|--------|
| Cold Start | ≤ 1.2s |
| Frame Rate | ≥ 55 FPS |
| Memory Peak | ≤ 350MB |
| DB Query | ≤ 15ms |
| Network Request | ≤ 800ms |

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
