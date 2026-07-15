# Fixit Vietnam

A specialized platform for mobile device repairs and technician services.

## Technology Stack

- **Framework:** Flutter
- **State Management:** Riverpod (with Code Generation)
- **Navigation:** GoRouter
- **Backend:** Appwrite (Auth, Databases, Storage, Realtime, Functions)
- **Environment:** Multi-flavor support (dev, prod)

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Appwrite Cloud project access for backend management

### Installation

1. Clone the repository:
   ```bash
   git clone <repo-url>
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Running the App

The app uses flavors for different environments. Use the following commands to run:

- **Development:** `flutter run --flavor dev -t lib/core/entrypoints/main_dev.dart`
- **Production:** `flutter run --flavor prod -t lib/core/entrypoints/main_prod.dart`

## Testing

Run all unit and widget tests:
```bash
flutter test
```

## Project Structure

- `lib/core`: App-wide configurations, routing, themes, and utilities.
- `lib/features`: Feature-based modules (Auth, Home, Guides, Marketplace, Booking, etc.).
- `lib/shared`: Shared widgets, models, and services.
- `lib/core/config/appwrite_provider.dart`: Appwrite client/services configured per flavor.
