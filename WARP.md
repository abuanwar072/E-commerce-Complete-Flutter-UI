# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

### Setup
```bash
flutter pub get
cd ios && pod install && cd -  # iOS setup for CocoaPods
```

### Run
```bash
flutter run -d ios          # Run on iOS simulator/device
flutter run -d android      # Run on Android emulator/device
flutter run -d chrome       # Run in web browser (if web support added)
```

### Build
```bash
flutter build apk --release           # Android APK
flutter build appbundle --release     # Android App Bundle
flutter build ios --release --no-codesign  # iOS (for testing)
```

### Lint and Format
```bash
flutter analyze                # Static analysis with flutter_lints
dart format --fix .           # Format code
dart fix --apply              # Apply automated fixes
```

### Tests
```bash
flutter test                                    # Run all tests
flutter test test/widget_test.dart             # Run single test file
flutter test --plain-name "Counter increments" # Run specific test
flutter test --coverage                        # Generate coverage report
```

## Architecture Overview

### App Bootstrap
- **Entry point**: `lib/main.dart` → `MyApp` widget
- **Main navigation**: `lib/entry_point.dart` → Bottom navigation with 5 tabs (Home, Discover, Bookmark, Cart, Profile)
- **Routing**: Custom route system in `lib/route/router.dart` with named routes

### Navigation Structure
- **Route configuration**: `lib/route/route_constants.dart` for route names
- **Screen exports**: `lib/route/screen_export.dart` centralizes all screen imports
- **Navigation style**: Traditional Flutter Navigator with named routes
- **Bottom tabs**: Home, Discover, Bookmark, Cart, Profile screens

### UI Architecture
- **Theme system**: `lib/theme/app_theme.dart` with light theme (dark theme available in full template)
- **Design system**: 
  - Custom colors defined in `lib/constants.dart`
  - Plus Jakarta and Grandis Extended fonts
  - Consistent spacing with `defaultPadding` constant
- **Components**: Reusable UI components in `lib/components/` (banners, products, skeletons)

### Feature Organization
- **Screens**: Organized by feature in `lib/screens/` (auth, home, product, profile, etc.)
- **Models**: Product and category models in `lib/models/`
- **Assets**: Organized by type in `assets/` (images, icons, illustrations, flags, logos)

### Data Layer
- **State management**: Standard Flutter StatefulWidget pattern (no external state management)
- **Models**: Simple Dart classes for Product and Category
- **Demo data**: Uses placeholder images from imgur for product demonstrations
- **API integration**: Template structure ready for backend integration

### Key Features
- **E-commerce screens**: 100+ screens including onboarding, auth, product details, cart, checkout, profile
- **Form validation**: Uses `form_field_validator` for email and password validation
- **Image handling**: `cached_network_image` for efficient image loading
- **Icons**: SVG icons with `flutter_svg`
- **Page transitions**: Uses `animations` package for smooth transitions

### Template Notes
- This is a premium UI template with many screens commented out in the free version
- Full template available at: https://theflutterway.gumroad.com/l/fluttershop
- Template focuses on UI/UX rather than backend integration
- Ready for customization with preferred backend (Firebase, WordPress, custom API)