# Location Service App

A Flutter application demonstrating location services and advice feature with clean architecture.

## Features

- **Home Screen** with draggable bottom sheets
- **Advice Feature**: Fetch random advice from API with clean architecture (Domain, Data, Presentation layers)
- **GPS Feature**: Location tracking functionality (UI ready)
- **Clean Architecture**: Organized codebase following best practices
- **State Management**: Using Cubit/Bloc pattern
- **Dependency Injection**: GetIt for managing dependencies

## Tech Stack

- **Flutter**: Cross-platform mobile framework
- **Bloc/Cubit**: State management
- **Dio**: HTTP client for API calls
- **GetIt**: Dependency injection
- **Equatable**: Value equality
- **flutter_svg**: SVG rendering

## Project Structure

```diagram
lib/
├── core/
│   ├── di/              # Dependency injection setup
│   └── error/           # Error handling (exceptions, failures)
├── features/
│   └── home/
│       ├── data/        # Data layer (repositories, data sources, models)
│       ├── domain/      # Domain layer (entities, repositories, use cases)
│       └── presentation/  # Presentation layer (UI, Cubit, pages, widgets)
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK: **3.29.2** (using FVM)
- Dart SDK (included with Flutter)
- FVM (Flutter Version Management) - recommended

### Development Environment

```text
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.29.2, on macOS 15.3.2 24D81 darwin-arm64, locale en-VN)
[✓] Android toolchain - develop for Android devices (Android SDK version 36.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 16.2)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2024.3)
[✓] IntelliJ IDEA Ultimate Edition (version 2025.2.6)
[✓] VS Code (version 1.108.2)
[✓] Connected device (6 available)
[✓] Network resources

• No issues found!
```

### Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd location_service_app
```

### 2. Setup Flutter version with FVM (recommended)

```bash
fvm install 3.29.2
fvm use 3.29.2
```

Or install Flutter 3.29.2 manually if not using FVM.

### 3. Install dependencies

```bash
fvm flutter pub get
# or without FVM:
# flutter pub get
```

### 4. Run the app

```bash
fvm flutter run
# or without FVM:
# flutter run
```

## API Integration

The app uses the [Advice Slip API](https://api.adviceslip.com) to fetch random advice.

- Endpoint: `https://api.adviceslip.com/advice`
- Timeout: 30 seconds
- Includes request/response logging

## Clean Architecture Layers

### Domain Layer

- **Entities**: Pure Dart objects representing business models
- **Repositories**: Abstract definitions of data operations
- **Use Cases**: Business logic implementation

### Data Layer

- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: API communication layer
- **Repository Implementations**: Concrete repository implementations

### Presentation Layer

- **Pages**: Screen UI
- **Widgets**: Reusable UI components
- **Cubit**: State management logic

## Contributing

Feel free to submit issues and pull requests.

## License

This project is open source and available under the MIT License.
