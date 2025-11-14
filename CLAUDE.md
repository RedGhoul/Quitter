# CLAUDE.md - Quitter Codebase Guide

**Last Updated:** 2025-11-14
**Project Version:** 1.0.92+94
**Primary Language:** Dart (Flutter)

## Project Overview

**Quitter** is a free and open-source cross-platform application for tracking addiction recovery journeys. It helps users monitor their progress in quitting various addictions (alcohol, smoking, vaping, marijuana, opioids, nicotine pouches, social media, and pornography) with features like milestone tracking, journaling, and motivational notifications.

**Core Principles:**
- **Privacy First:** No tracking, no internet access required - all data stored locally
- **Cross-Platform:** Supports Android, iOS, Windows, macOS, Linux, and Web
- **Fully Customizable:** Toggleable features, themes, and custom journeys
- **Open Source:** MIT licensed, community-driven development

**Distribution Channels:**
- Google Play Store: `com.quitter.app`
- Microsoft Store: `9PKVZWDG3FGC`
- Web: https://brandonp2412.github.io/Quitter/
- App Store (iOS)
- Direct downloads for desktop platforms

---

## Architecture & Design Patterns

### State Management
**Provider Pattern** with `ChangeNotifier`:
- **`AddictionProvider`** (lib/addiction_provider.dart) - Manages all addiction tracking data
- **`SettingsProvider`** (lib/settings_provider.dart) - Manages user preferences and app settings

Both providers use `SharedPreferences` for persistent local storage with JSON serialization.

### Data Persistence
- **SharedPreferences:** Simple key-value storage for settings and addiction dates
- **JSON Serialization:** Complex objects (Entry, milestones, journal entries) stored as JSON strings
- **No Database:** Intentionally lightweight - no SQLite or external databases
- **Platform-agnostic:** Works identically across all platforms

### Navigation Pattern
- **TabController:** Main navigation between Home, Journal (optional), and Settings
- **MaterialPageRoute:** Standard navigation for detail pages
- **Modal Bottom Sheets:** User confirmations and quick actions

### Key Data Models

**Entry** (lib/entry.dart):
```dart
class Entry {
  String id;           // UUID
  String title;        // Custom addiction name
  String? quitDate;    // ISO 8601 date string
  int color;           // Color value
  String icon;         // Icon identifier
  List<int> days;      // Days achieved tracking
}
```

**Architecture Highlights:**
- Single `main.dart` entry point with `MultiProvider` setup
- Flat file structure in `lib/` (no subdirectories)
- Page-based organization: one file per major screen
- Reusable widgets: `QuitCard`, `TimelineTile`, `IconPicker`
- Background tasks via `WorkManager` for notifications
- Lifecycle monitoring for PIN timeout security

---

## Directory Structure

```
/home/user/Quitter/
├── lib/                      # Main Dart source code (33 files, ~6,500 lines)
│   ├── main.dart            # App entry point, providers, tab navigation
│   ├── addiction_provider.dart  # State management for addiction data
│   ├── settings_provider.dart   # State management for settings
│   ├── tasks.dart           # Background tasks & notifications
│   ├── entry.dart           # Custom entry data model
│   │
│   ├── home_page.dart       # Main screen with addiction cards
│   ├── journal_page.dart    # Journaling interface (19.7KB)
│   ├── settings_page.dart   # Settings UI (26.5KB)
│   ├── quit_milestones_page.dart  # Milestone tracking
│   ├── edit_entry_page.dart # Custom entry editor
│   ├── pin_page.dart        # PIN authentication
│   │
│   ├── alcohol_page.dart    # Specific addiction pages
│   ├── smoking_page.dart
│   ├── vaping_page.dart
│   ├── marijuana_page.dart
│   ├── opioid_page.dart
│   ├── nicotine_pouches.dart
│   ├── social_media_page.dart
│   ├── pornography_page.dart
│   │
│   ├── quit_card.dart       # Reusable addiction card widget
│   ├── quit_milestone.dart  # Milestone data model
│   ├── timeline_tile.dart   # Timeline visualization
│   ├── confetti_widget.dart # Celebration animations
│   ├── icon_picker.dart     # Icon selection UI
│   ├── cupertino_icons.dart # Icon mappings (25.7KB)
│   ├── utils.dart           # Utility functions
│   ├── app_scheme.dart      # Color schemes
│   ├── app_theme_mode.dart  # Theme management
│   └── whats_new.dart       # Changelog viewer
│
├── test/                     # Unit tests (4 files, ~1,200 lines)
│   ├── home_page_test.dart
│   ├── settings_page_test.dart
│   ├── journal_page_test.dart
│   └── pin_page_test.dart
│
├── integration_test/         # Integration tests
│   └── screenshot_test.dart  # Automated screenshot generation
│
├── test_driver/              # Test driver configuration
│   └── integration_test.dart
│
├── android/                  # Android-specific code
│   ├── app/build.gradle.kts  # Android build config (Kotlin DSL)
│   ├── app/keystore.jks      # Signing keystore (gitignored)
│   └── key.properties        # Signing keys (gitignored)
│
├── ios/                      # iOS-specific code (Xcode project)
├── macos/                    # macOS desktop app
├── linux/                    # Linux desktop app (CMake)
├── windows/                  # Windows desktop app (CMake)
├── web/                      # Web app (HTML/manifest)
│
├── fastlane/                 # Release automation
│   └── metadata/android/en-US/changelogs/  # Play Store changelogs
│
├── assets/                   # Images, icons, changelogs
│   ├── icon.png             # App icon
│   └── changelogs/          # Timestamped changelog files
│
├── .github/workflows/        # CI/CD pipelines
│   └── main.yml             # Build & deploy workflow (292 lines)
│
├── docs/                     # Documentation & badges
├── pubspec.yaml             # Flutter dependencies & version
├── pubspec.lock             # Locked dependency versions
├── analysis_options.yaml    # Dart linting rules
├── flutter_launcher_icons.yaml  # Icon generation config
├── deploy.sh                # Local deployment script (278 lines)
├── Gemfile                  # Ruby dependencies (Fastlane)
├── README.md                # User-facing documentation
├── CONTRIBUTING.md          # Contribution guidelines
└── LICENSE.md               # MIT License
```

---

## Key Dependencies

**Core Framework:**
- `flutter: sdk: flutter` - Flutter SDK ^3.9.0
- `cupertino_icons: ^1.0.8` - iOS-style icons

**State Management & Storage:**
- `provider: ^6.1.5` - Reactive state management
- `shared_preferences: ^2.5.3` - Local key-value storage

**UI & Theming:**
- `dynamic_color: ^1.8.1` - Material You dynamic theming
- `flutter_svg: ^2.0.13` - SVG rendering

**Notifications & Background:**
- `flutter_local_notifications: ^19.4.0` - Platform notifications
- `workmanager: ^0.9.0+2` - Background task scheduling
- `home_widget: ^0.8.0` - Android home screen widgets

**Utilities:**
- `permission_handler: ^12.0.1` - Runtime permissions
- `url_launcher: ^6.3.2` - Open URLs
- `file_picker: ^8.0.0+1` - File selection
- `share_plus: ^12.0.0` - Share functionality
- `package_info_plus: ^8.3.1` - App version info
- `intl: ^0.20.2` - Internationalization
- `path_provider: ^2.1.3` - System paths
- `uuid: ^4.5.1` - UUID generation
- `crypto: ^3.0.6` - SHA256 hashing (PIN security)

**Build Tools:**
- `msix: ^3.16.12` - Windows Store packaging
- `flutter_launcher_icons: ^0.14.4` - Icon generation
- `flutter_lints: ^6.0.0` - Dart linting

---

## Development Workflow

### Prerequisites
1. **Flutter SDK:** Version 3.9.0 or higher
2. **Dart:** Comes with Flutter
3. **Git:** For version control and submodule management
4. **Platform-specific tools:**
   - Android: Android Studio, Java 17
   - iOS: Xcode (macOS only)
   - Windows: Visual Studio with C++ tools
   - Linux: GTK 3, CMake, Ninja
   - Web: Chrome

### Initial Setup

```bash
# Clone repository
git clone https://github.com/brandonp2412/Quitter.git
cd Quitter

# Initialize Flutter submodule
git submodule update --init --recursive flutter
export PATH="$PWD/flutter/bin:$PATH"

# Get dependencies
flutter pub get

# Verify installation
flutter doctor
```

### Common Development Commands

```bash
# Run on connected device/emulator
flutter run

# Run with device selection
flutter devices
flutter run -d <device-id>

# Hot reload: Press 'r' in terminal while app is running
# Hot restart: Press 'R' in terminal

# Run tests
flutter test                          # Unit tests
flutter test integration_test         # Integration tests (requires device)

# Code analysis
flutter analyze                       # Static analysis
dart format lib                       # Format code
dart format --set-exit-if-changed lib # Check formatting

# Build for specific platforms
flutter build apk                     # Android APK
flutter build appbundle               # Android App Bundle
flutter build ios                     # iOS (macOS only)
flutter build windows                 # Windows
flutter build linux                   # Linux
flutter build macos                   # macOS
flutter build web --release           # Web

# Clean build cache
flutter clean
flutter pub get
```

### Testing Strategy

**Unit Tests** (`test/` directory):
- Test widget rendering and behavior
- Use `testWidgets()` for widget tests
- Mock providers with `ChangeNotifierProvider`
- Coverage: home page, settings, journal, PIN authentication

**Integration Tests** (`integration_test/` directory):
- Screenshot generation for app store listings
- Uses `flutter drive` command
- Runs on real devices/emulators
- Device type passed via `--dart-define=QUITTER_DEVICE_TYPE=<type>`

**Running Tests:**
```bash
# All unit tests
flutter test

# Specific test file
flutter test test/home_page_test.dart

# Integration tests (requires emulator/device)
flutter test -d linux integration_test
flutter drive --target=integration_test/screenshot_test.dart
```

---

## Release & Deployment

### Version Management

**Version Format:** `major.minor.patch+buildNumber`
- Current: `1.0.92+94`
- Defined in: `pubspec.yaml` line 4
- MSIX version (Windows): `1.0.79.0` (different format)

**Versioning Rules:**
- `patch`: Incremented for bug fixes and minor changes
- `buildNumber`: Incremented with every release
- Changelog number: `buildNumber * 10 + 3`

### Local Deployment Script

**`deploy.sh`** - Automated local release process:

```bash
# Full release (with screenshot generation)
./deploy.sh

# Quick release (skip screenshots)
./deploy.sh -n
```

**What it does:**
1. Validates `yq` tool is installed (mikefarah's Go version)
2. Calculates new version numbers
3. Generates changelog from git commits since last tag
4. Runs tests: `flutter test`
5. Runs integration tests: `flutter test -d linux integration_test`
6. Runs analysis: `dart analyze lib`
7. Verifies formatting: `dart format --set-exit-if-changed lib`
8. Updates versions in `pubspec.yaml`
9. Copies changelogs with timestamps to `assets/changelogs/`
10. Generates screenshots on Android emulators (phoneScreenshots, sevenInchScreenshots, tenInchScreenshots)
11. Commits changes with message: `Release X.X.X`
12. Creates git tag: `X.X.X`
13. Builds for available platforms (macOS, Linux, Windows, Web)
14. Pushes commits and tags to remote

**Requirements:**
- `yq` (Go version by mikefarah)
- Android emulators configured (if not skipping screenshots)
- Git configured

### CI/CD Pipeline

**GitHub Actions** (`.github/workflows/main.yml`):

**Trigger:** Push tags matching `[0-9]+.[0-9]+.[0-9]+`

**Jobs:**
1. **get-version-info** - Extracts version from tag
2. **build-android** - Builds AppBundle and split APKs
3. **build-linux** - Builds Linux desktop app
4. **build-windows** - Builds Windows desktop app
5. **build-web** - Builds and deploys to GitHub Pages
6. **release** - Creates GitHub release with all artifacts

**Artifacts:**
- Android: `.aab` + split APKs (x86_64, armeabi-v7a, arm64-v8a)
- Linux: Zipped bundle
- Windows: Zipped bundle
- Web: Deployed to GitHub Pages

**Secrets Required:**
- `ANDROID_KEYSTORE_BASE64` - Base64-encoded keystore
- `ANDROID_STORE_PASSWORD` - Keystore password
- `ANDROID_KEY_PASSWORD` - Key password
- `ANDROID_KEY_ALIAS` - Key alias

### Changelog Generation

**Format:** Bullet points from git commits
**Location:** `fastlane/metadata/android/en-US/changelogs/<number>.txt`
**Process:**
```bash
git log --pretty=format:'%s' <last-tag>..HEAD | \
  sort -u | \
  grep -v "^Merge " | \
  grep -v "^Release " | \
  head -10 | \
  sed 's/^/• /'
```

**Filters out:**
- Merge commits
- Release commits
- Bump commits
- Update commits
- Version number commits

---

## Code Conventions & Patterns

### File Naming
- **Lowercase with underscores:** `addiction_provider.dart`, `quit_card.dart`
- **Page suffix:** Pages end with `_page.dart`
- **Provider suffix:** Providers end with `_provider.dart`
- **No subdirectories** in `lib/` - flat structure

### Code Style
- **Linting:** Uses `flutter_lints: ^6.0.0`
- **Formatting:** Enforced with `dart format`
- **Material Design 3:** `useMaterial3: true` in theme
- **Const constructors:** Preferred for performance
- **Private members:** Prefix with underscore (`_tabController`)

### Widget Patterns
```dart
// Stateless widgets for static content
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
}

// Stateful widgets for dynamic content
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

// Consumer pattern for Provider
Consumer<SettingsProvider>(
  builder: (context, settings, child) {
    return Widget();
  },
)
```

### State Management Pattern
```dart
// In Provider class
class MyProvider extends ChangeNotifier {
  Future<void> updateData() async {
    // Update state
    notifyListeners(); // Trigger rebuild
  }
}

// In widget
final provider = Provider.of<MyProvider>(context);
// or
final provider = context.read<MyProvider>();
```

### SharedPreferences Pattern
```dart
// String values
_pref?.setString('key', value);
final value = _pref?.getString('key');

// JSON serialization for complex objects
final json = jsonEncode(object.toJson());
_pref?.setString('key', json);

final jsonString = _pref?.getString('key');
final object = MyClass.fromJson(jsonDecode(jsonString));
```

### Navigation Pattern
```dart
// Push new page
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => MyPage(),
  ),
);

// Pop current page
Navigator.of(context).pop();

// Modal bottom sheet
showModalBottomSheet(
  context: context,
  builder: (context) => MyBottomSheet(),
);
```

---

## Common Development Tasks

### Adding a New Addiction Type

1. **Create page file:** `lib/my_addiction_page.dart`
2. **Add to provider:**
   - Add field in `AddictionProvider`
   - Add getter method
   - Update `loadAddictions()`
3. **Add to home page:**
   - Import page in `home_page.dart`
   - Add `QuitCard` widget with navigation
4. **Add to settings:**
   - Add toggle in `settings_page.dart`
5. **Add studies/benefits:**
   - Create informational widgets in page
   - Reference authoritative, public sources

### Modifying Settings

1. **Add to SettingsProvider:**
   - Add field and getter
   - Load in `loadPreferences()`
   - Add setter with `notifyListeners()`
2. **Add UI in settings_page.dart:**
   - Add switch/toggle widget
   - Bind to provider value
3. **Use in app:**
   - Access via `context.read<SettingsProvider>()`

### Adding Notifications

1. **Define message:** Add to notification messages in `tasks.dart`
2. **Schedule:** Use WorkManager for periodic tasks
3. **Permissions:** Handled in `tasks.dart` with `permission_handler`
4. **Platform-specific:** Check `defaultTargetPlatform` before calling

### Updating Icons

1. **Modify:** `flutter_launcher_icons.yaml`
2. **Generate:** `flutter pub run flutter_launcher_icons`
3. **Verify:** Check all platform directories

### Adding Dependencies

1. **Edit:** `pubspec.yaml`
2. **Get packages:** `flutter pub get`
3. **Import:** `import 'package:package_name/package_name.dart';`

---

## Important Considerations

### Privacy & Security

**No Internet Access:**
- App does not request internet permissions
- All data stored locally
- No analytics, tracking, or telemetry

**PIN Security:**
- SHA256 hashing for PIN storage
- Timeout-based app locking
- Lifecycle monitoring for privacy

**Data Storage:**
- Everything in SharedPreferences
- No cloud backup
- User data never leaves device

### Cross-Platform Considerations

**Platform Detection:**
```dart
import 'package:flutter/foundation.dart';

if (defaultTargetPlatform == TargetPlatform.android) {
  // Android-specific code
}
```

**Platform-Specific Features:**
- Home widgets: Android only
- WorkManager: Android & iOS (different implementations)
- Notifications: Platform-specific permissions

**Web Limitations:**
- No background tasks
- No local notifications
- File picker limitations
- SharedPreferences uses localStorage

### Performance

**Best Practices:**
- Use `const` constructors wherever possible
- Avoid rebuilding entire widget tree
- Use `Consumer` for specific provider updates
- Lazy load heavy content
- Optimize image assets

### Testing

**Widget Tests:**
```dart
testWidgets('Description', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('Expected'), findsOneWidget);
});
```

**Provider Mocking:**
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MockProvider()),
  ],
  child: MyWidget(),
)
```

---

## Troubleshooting

### Common Issues

**1. Build Failures:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

**2. Submodule Issues:**
```bash
git submodule update --init --recursive flutter
```

**3. Android Build Issues:**
- Check Java version: `java -version` (should be 17)
- Verify Kotlin version in `android/build.gradle.kts` (2.1.0)
- Clean Android build: `cd android && ./gradlew clean`

**4. Screenshot Generation Fails:**
- Verify emulator is configured: `emulator -list-avds`
- Check emulator names match: phoneScreenshots, sevenInchScreenshots, tenInchScreenshots
- Run with `-n` flag to skip: `./deploy.sh -n`

**5. yq Version Issues:**
```bash
# Install correct version (Linux)
wget -qO /tmp/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo mv /tmp/yq /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq

# Install correct version (macOS)
brew install yq
```

**6. Test Failures:**
- Ensure providers are properly mocked
- Check widget tree structure hasn't changed
- Verify test data matches expected values

---

## Git Workflow

### Branch Strategy
- **main:** Production-ready code
- **Feature branches:** For new features
- **Version tags:** Format `X.X.X` (no 'v' prefix)

### Commit Messages
- Keep concise and descriptive
- Use imperative mood: "Add feature" not "Added feature"
- Reference issues when applicable

### Release Process
1. Run `./deploy.sh` locally
2. Script creates commit: `Release X.X.X`
3. Script creates tag: `X.X.X`
4. Script pushes to origin
5. GitHub Actions triggers on tag
6. Builds are created and released automatically

---

## Resources

**Documentation:**
- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Material Design 3: https://m3.material.io/

**Repository:**
- GitHub: https://github.com/brandonp2412/Quitter
- Issues: https://github.com/brandonp2412/Quitter/issues
- Releases: https://github.com/brandonp2412/Quitter/releases

**Distribution:**
- Play Store: https://play.google.com/store/apps/details?id=com.quitter.app
- Microsoft Store: https://apps.microsoft.com/detail/9PKVZWDG3FGC
- Web App: https://brandonp2412.github.io/Quitter/

---

## Contributing Guidelines

From `CONTRIBUTING.md`:

**Code Standards:**
- "I'm not picky" - No strict coding standards
- Features/bugfixes accepted if maintainer enjoys them
- Code should follow general Dart/Flutter best practices

**Studies/Benefits References:**
1. Must be from authoritative sources
2. Must be publicly available
3. Simple URLs that will stay up long-term
4. Scholarly/scientific evidence preferred
5. Avoid overly technical references - keep it simple

**Pull Request Process:**
1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit PR with clear description
6. Wait for review

---

## Quick Reference

### File Locations
- **Main entry:** `lib/main.dart`
- **State management:** `lib/addiction_provider.dart`, `lib/settings_provider.dart`
- **Pages:** `lib/*_page.dart`
- **Tests:** `test/*_test.dart`
- **Version:** `pubspec.yaml` line 4
- **Dependencies:** `pubspec.yaml` lines 7-27
- **Build config:** `android/app/build.gradle.kts`, `linux/CMakeLists.txt`, etc.

### Key Commands
```bash
flutter run              # Run app
flutter test             # Run tests
flutter analyze          # Static analysis
dart format lib          # Format code
flutter build <platform> # Build for platform
./deploy.sh              # Release process
```

### Important Variables
- **Version:** `1.0.92+94` (in `pubspec.yaml`)
- **Kotlin:** `2.1.0`
- **Java:** `17`
- **Flutter SDK:** `^3.9.0`
- **Dart SDK:** `^3.9.0`

---

**End of CLAUDE.md**

*This document is maintained to help AI assistants understand and work effectively with the Quitter codebase. Keep it updated as the project evolves.*
