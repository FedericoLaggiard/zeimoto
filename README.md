# Zeimoto

![Flutter](https://img.shields.io/badge/Flutter-Mobile%20%26%20Web-02569B.svg)
![Dart SDK](https://img.shields.io/badge/Dart-%5E3.10.0-blue.svg)
[![CI](https://github.com/FedericoLaggiard/zeimoto/actions/workflows/ci.yml/badge.svg)](https://github.com/FedericoLaggiard/zeimoto/actions/workflows/ci.yml)

Zeimoto is a mobile and web application for managing bonsai, powered by generative AI.

## How to Run

- Install Flutter and set up a device or emulator: https://docs.flutter.dev/get-started/install
- Fetch dependencies: `flutter pub get`
- Run on mobile (Android/iOS): `flutter run`
- Run on web (Chrome): `flutter run -d chrome`
- Optional checks: `flutter analyze` and `flutter test`

## Requirements

- Dart SDK: `^3.10.0` (see `pubspec.yaml`)
- Flutter: Stable channel compatible with Dart 3.10
- Android: Android SDK (latest) and a device/emulator
- iOS/macOS: Xcode with command line tools

## Upcoming Steps

- [ ] Integrate the plant work wizard
- [ ] Integrate the wiki for plants and bonsai, add support for YouTube videos
- [ ] Add a calendar with recommended work for plant types
- [ ] Add a calendar of completed work
- [ ] Add the plant gallery
- [ ] Add settings
- [ ] Add the help section

## Tech Stack

- Flutter (mobile and web UI)
- Hive (local storage) in `lib/services/` and models in `lib/models/`
- GoRouter (routing) in `lib/app/routes.dart`
- Image Picker (photo capture/import) in `lib/services/photo_service.dart`
- url_launcher (external links) in `lib/screens/wiki_screen.dart`
- uuid (ID generation) in repositories/services

## Project Structure

- `lib/app/routes.dart` — central route configuration
- `lib/screens/` — feature screens (home, start, plant detail, add plant, wiki)
- `lib/screens/start_screen/widgets/` — start screen UI components and drag grid
- `lib/widgets/` — reusable UI elements (cards, timeline, photo grid, banners)
- `lib/services/` — data and domain services (photos, suggestions, interventions, plants)
- `lib/models/` — core entities and enums
- `lib/l10n/` — localization utilities
