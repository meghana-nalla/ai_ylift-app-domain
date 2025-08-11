# YLift Flutter E-Commerce Application

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Quick Navigation for Common Tasks

### Immediate Development Setup
1. `flutter doctor -v` -- verify Flutter installation
2. `flutter pub get` -- install dependencies (2-5 minutes)
3. `flutter pub run build_runner build` -- generate required files (3-8 minutes)
4. `flutter run -d chrome` -- start development server (3-5 minutes)

### Code Locations for Common Changes
- **Add new products**: `lib/models/simple/product_display.dart` and `lib/presentation/components/products/`
- **Modify authentication**: `lib/core/controllers/auth/` and `lib/core/services/bearer.dart`
- **Update UI components**: `lib/presentation/components/` (organized by component type)
- **Add new pages**: `lib/presentation/pages/desktop/` or `lib/presentation/pages/mobile/`
- **Configure API endpoints**: `lib/models/urls/api.dart`
- **Update navigation**: `lib/core/routes/index.dart`

## CRITICAL: Network Access Requirements

This project has specific network dependencies that may fail in restricted environments:

### Required Network Access
- **storage.googleapis.com**: For Flutter SDK downloads and Dart SDK downloads
- **pub.dev**: For Dart package dependencies
- **github.com**: For private repository access (galaxy_ui and galaxy_models)
- **packages.cloud.google.com**: For additional Flutter tooling

### Alternative Installation Methods if Network Restricted
1. **Manual Flutter Installation**: Download Flutter SDK locally and extract to `/opt/flutter` or similar
2. **Package Cache**: Use pre-cached pub dependencies if available
3. **Offline Development**: Work with existing code without rebuilds if network unavailable
4. **SSH Tunnel**: Use SSH tunneling for private repository access if needed

### Network Troubleshooting Commands
- `curl -I https://storage.googleapis.com` -- test Google storage access
- `curl -I https://pub.dev` -- test Dart package registry access
- `ssh -T git@github.com` -- test GitHub SSH access
- `flutter doctor -v` -- comprehensive system check including network dependencies


## Working Effectively

### Prerequisites and Setup
- **CRITICAL**: Install Flutter SDK 3.7.0+ using the official installation guide
- **NETWORK REQUIREMENT**: Stable internet connection required for downloads and builds
- **CRITICAL**: Ensure you have SSH access to private GitHub repositories (galaxy_ui and galaxy_models)
- Configure SSH keys for Git access to `git@github.com:Y-LIFT-Store/galaxy-ui.git` and `git@github.com:Y-LIFT-Store/galaxy-models.git`
- Install Dart SDK (typically included with Flutter)
- Ensure Git is installed and configured
- **Note**: Some environments may have network restrictions. If Flutter installation fails due to network issues, try alternative installation methods or request network access.

### Essential Commands with Timing
- **Flutter Doctor**: `flutter doctor -v` -- verifies installation. Takes 10-30 seconds.
- **Dependencies**: `flutter pub get` -- downloads all dependencies. Takes 2-5 minutes. NEVER CANCEL.
- **Code Generation**: `flutter pub run build_runner build` -- generates .g.dart files. **REQUIRED AFTER MODEL CHANGES**. Takes 3-8 minutes. NEVER CANCEL. Set timeout to 15+ minutes.
- **Clean Build**: `flutter pub run build_runner build --delete-conflicting-outputs` -- for conflicting generated files. Takes 5-10 minutes. NEVER CANCEL.
- **Analysis**: `flutter analyze` -- code analysis and linting. Takes 30-60 seconds.
- **Format**: `flutter format .` -- code formatting. Takes 10-30 seconds.

### Build Commands with CRITICAL Timing Warnings
- **Web Build**: `flutter build web` -- builds for web deployment. Takes 8-15 minutes. **NEVER CANCEL**. Set timeout to 25+ minutes.
- **Android Build**: `flutter build apk` -- builds Android APK. Takes 10-20 minutes. **NEVER CANCEL**. Set timeout to 30+ minutes.
- **iOS Build**: `flutter build ios` -- builds iOS app (Mac only). Takes 15-25 minutes. **NEVER CANCEL**. Set timeout to 35+ minutes.
- **Debug Build**: `flutter build apk --debug` -- faster debug builds. Takes 3-8 minutes. **NEVER CANCEL**. Set timeout to 15+ minutes.

### Running the Application
- **Web Development**: `flutter run -d chrome --web-renderer html` -- starts dev server. Takes 3-5 minutes initial build. **NEVER CANCEL**. Set timeout to 10+ minutes.
- **Web Development (Fast)**: `flutter run -d chrome --web-renderer canvaskit` -- alternative renderer, may be faster on some systems.
- **Mobile Simulator**: `flutter run -d android` or `flutter run -d ios` -- runs on simulator. Takes 5-10 minutes first run. **NEVER CANCEL**. Set timeout to 15+ minutes.
- **Hot Reload**: Press `r` in the running Flutter session for hot reload (2-5 seconds)
- **Hot Restart**: Press `R` in the running Flutter session for hot restart (10-30 seconds)
- **Web Hot Reload**: Web hot reload can be slower (5-15 seconds) due to web compilation

### Testing Commands
- **Unit Tests**: `flutter test` -- runs all tests. Takes 1-3 minutes. **NEVER CANCEL**. Set timeout to 5+ minutes.
- **Widget Tests**: `flutter test test/widget_test.dart` -- runs widget tests specifically. Takes 30-60 seconds.
- **Integration Tests**: `flutter drive --target=test_driver/app.dart` -- if integration tests exist. Takes 5-15 minutes. **NEVER CANCEL**. Set timeout to 20+ minutes.

## Validation Scenarios

### CRITICAL: Always Test These Scenarios After Changes
1. **Authentication Flow**: 
   - Navigate to login page
   - Test with valid/invalid credentials
   - Verify token persistence
   - Test logout functionality

2. **Product Browsing**:
   - Navigate to shop page (/shop)
   - Test product category filtering
   - Test product search functionality
   - View individual product details

3. **Shopping Cart**:
   - Add products to cart
   - Modify quantities
   - Remove items
   - Test cart persistence across sessions

4. **Web Application Validation**:
   - Run `flutter run -d chrome --web-renderer html`
   - Verify application loads at localhost (typically port 3000 or higher)
   - Test responsive design by resizing browser window
   - Check browser developer tools for console errors
   - Verify favicon and web manifest load correctly
   - Test PWA functionality if applicable

5. **API Integration**:
   - Verify network requests work
   - Test offline handling
   - Verify bearer token authentication
   - Test error handling for failed requests

### Manual Validation Requirements
- **ALWAYS** run through complete user scenarios after making changes
- **ALWAYS** test both mobile and desktop layouts
- **ALWAYS** verify API endpoints are working correctly
- **ALWAYS** check console for errors and warnings
- **NEVER** skip validation because it's taking time

## Project Architecture

### Core Structure
- **`lib/core/`**: Business logic, controllers, services, and utilities
- **`lib/models/`**: Data models (API, simple, and URL definitions)
- **`lib/presentation/`**: UI components, layouts, and pages
- **`lib/main.dart`**: Application entry point with initialization

### Key Controllers (GetX Pattern)
- **GlobalController**: Central coordinator for all app state
- **Auth0Controller**: Authentication and user management
- **CartController**: Shopping cart operations
- **ProductsController**: Product data and operations
- **DisplayController**: UI state and navigation

### Important Files for Common Changes
- **Add new API endpoints**: Edit `lib/models/urls/api.dart`
- **Modify authentication**: Edit `lib/core/controllers/auth/index.dart`
- **Update product display**: Edit `lib/presentation/components/products/`
- **Change navigation**: Edit `lib/core/routes/index.dart`
- **Add new pages**: Add to `lib/presentation/pages/desktop/` or `lib/presentation/pages/mobile/`

### Code Generation Requirements
- **Models**: Many models use JSON serialization requiring `flutter pub run build_runner build`
- **Routes**: Generated route bindings in GetX
- **Assets**: Asset references generated from `pubspec.yaml`

## Development Workflow

### Before Making Changes
1. Run `flutter pub get` to ensure dependencies are current
2. Run `flutter pub run build_runner build` if working with models
3. Run `flutter analyze` to check for existing issues
4. Verify current functionality with `flutter run -d chrome`

### After Making Changes
1. **ALWAYS** run `flutter analyze` to check for new issues
2. **ALWAYS** run `flutter format .` to format code consistently
3. **ALWAYS** rebuild generated files: `flutter pub run build_runner build`
4. **ALWAYS** test your changes with `flutter run -d chrome`
5. **ALWAYS** verify responsive behavior on different screen sizes

### CI/CD Considerations
- The project uses GitHub Actions (`.github/workflows/backup-main.yml`)
- **ALWAYS** run `flutter analyze` and `flutter format .` before committing
- Ensure no build errors before pushing changes
- Private dependencies require SSH key access in CI

## Common Issues and Solutions

### Dependency Issues
- **Private dependency access denied**: Ensure SSH keys are configured for GitHub
- **Version conflicts**: Run `flutter pub deps` to see dependency tree
- **Build runner conflicts**: Use `flutter pub run build_runner build --delete-conflicting-outputs`
- **Missing .g.dart files**: Run `flutter pub run build_runner build` as mentioned in README.md

### Build Issues
- **Web build fails**: Try `flutter clean` then `flutter pub get` then rebuild
- **Generated files missing**: Run `flutter pub run build_runner build`
- **Network timeouts**: Ensure stable internet connection, builds download assets
- **Private repo access**: Ensure SSH keys are set up for Y-LIFT-Store repositories

### Runtime Issues
- **Authentication failures**: Check bearer token in network tab
- **API errors**: Verify backend API is accessible and endpoints are correct
- **Responsive layout issues**: Test with Flutter's device toolbar in browser

### Network and Installation Issues
- **Flutter download fails**: Network restrictions may prevent downloads from storage.googleapis.com
- **Snap installation fails**: Try manual Flutter installation or request network access
- **Dependencies timeout**: Use `flutter pub get --verbose` to see detailed download progress

## Performance Considerations

### Build Optimization
- Use `flutter build web --release` for production builds
- Enable tree-shaking with `--dart-define=flutter.inspector.structuredErrors=false`
- Consider `--split-debug-info` for release builds

### Development Optimization
- Use `--hot` flag for faster development iterations
- Consider `--profile` mode for performance testing
- Use Flutter DevTools for debugging and profiling

## Security Notes
- **Bearer tokens**: Handled automatically by `BearerTokenInterceptor`
- **API keys**: Stored in constants, ensure no secrets in version control
- **User data**: Persisted via `KodBoxService` with appropriate security measures

## External Dependencies
- **Galaxy UI**: Custom UI component library from Y-LIFT-Store
- **Galaxy Models**: Shared data models from Y-LIFT-Store
- **Auth0**: Authentication service integration
- **Dio**: HTTP client for API communication
- **GetX**: State management and navigation

## Common Task Outputs

### Repository Structure
```
ls -la /
.git                    → Git repository
.github/                → GitHub Actions and this file
.vscode/                → VS Code settings
lib/                    → Main Flutter source code
├── core/               → Business logic layer
├── models/             → Data models
├── presentation/       → UI components and pages
└── main.dart           → Application entry point
msc/                    → Static assets (images, fonts)
web/                    → Web platform configuration
android/                → Android platform files
ios/                    → iOS platform files
test/                   → Test files
pubspec.yaml            → Flutter project configuration
analysis_options.yaml  → Dart analysis rules
```

### Expected Flutter Commands Output
```bash
# flutter --version (successful)
Flutter 3.7.0 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 176c637fa8 (2 weeks ago) • 2024-07-29 11:17:06 -0700
Engine • revision f2b648cf51
Tools • Dart 3.1.0 • DevTools 2.25.0

# flutter doctor (successful)
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.7.0, on Linux)
[✓] Chrome - develop for the web
[✓] Linux toolchain - develop for Linux desktop

# flutter pub get (successful)
Running "flutter pub get" in ylift...
Resolving dependencies...
+ cupertino_icons 1.0.8
+ get 4.6.6
+ http 1.2.2
... (many more dependencies)
Changed 45 dependencies!

# flutter analyze (clean)
Analyzing ylift...
No issues found! (ran in 2.3s)

# flutter run -d chrome (successful startup)
Launching lib/main.dart on Chrome in debug mode...
Building application for the web...
lib/main.dart:1
Waiting for connection from debug service on Chrome...
This app is linked to the debug service: ws://127.0.0.1:9100/ws
Debug service listening on ws://127.0.0.1:9100/ws
```

Always verify these outputs match expectations and investigate any differences.