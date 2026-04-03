# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] - dd-mm-yyyy
Here we write the updates of future releases.

2.0.xx belongs to API Integration, Firebase Tools and other optimizations.

### Added
- API Integration

### Changed

### Deprecated

### Removed

### Fixed

### Security




## [2.0.0] - 03-04-2026

### Added
- Settings screen for import/export data UI
- Data Import/Export logic in "data_transfer_service.dart" file
- Screenshot controller map inside Home Screen State
- Common files to store all the app strings and bools
- Google services JSON file for Firebase configs
- API Client, URLs and Repositories

### Changed
- Package name to "**com.crb.sports_tracker**" in all relevant files
- Renamed enums file to "app_enums.dart"
- Screenshot Controller logic, moved it to Home Page Bloc
- Release apk name config in "android/app/build.gradle.kts" file
- Updated all models with JSON serializable annotations

### Removed
- Hardcode JSON data files for player and series data



## [1.0.4] - 02-04-2026

### Added
- Settings screen for import/export data UI
- Data Import/Export logic in "data_transfer_service.dart" file
- Screenshot controller map inside Home Screen State

### Changed
- Screenshot Controller logic, moved it to Home Page Bloc
- Release apk name config in "android/app/build.gradle.kts" file

### Removed
- Hardcode JSON data files for player and series data



## [1.0.3] - 27-03-2026

### Added
- Bloc logics for Match Screen
- Router file
- Screenshot Utility
- screenshot, path_provider and share_plus plugins

### Changed
- "Get color" cubit calls in match screen with more simplified and optimal methods.
- Statistics tile parameter with actual model



## [1.0.2] - 28-02-2026

### Added
- Bloc logics for Home Screen
- Player and Series data import
- Main models

### Changed
- "Get color" cubit calls in home screen with more simplified and optimal methods.
- Statistics tile parameter with actual model
- Player and Series widget mapped with actual data



## [1.0.1] - 25-02-2026

### Added
- All existing UI screens and widgets.
  - Home screen
  - Match screen and necessary widgets
  - Statistics screen
    - Player stats widget
    - Batting stats widget
    - Bowling stats widget
- Necessary basic components
  - Utils
  - Custom print
- Flutter bloc plugin
- Shared preference and equatable plugin
- In house UI Utility package
- App theme cubit

### Changed
- Main file and introduced folder hierarchy



## [1.0.0] - 20-02-2026

### Added
- All necessary startup files