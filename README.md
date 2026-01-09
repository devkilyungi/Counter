# Counter

A SwiftUI counter app built with The Composable Architecture (TCA 1.23.1) and Swift 6.

## Features
- Multi-tab experience: Primary, Optional, Combined, Settings
- Timer-driven auto-increment with adjustable speed (ticks per second)
- Combined counters with horizontal segmented paging
- Cat fact fetch via an injected `FactClient`
- Appearance control (system/light/dark) persisted via `ThemeClient`
- Counter presented in sheet or full-screen from Settings
- Tests written with Swift's `Testing` framework

## Structure
- `Counter/App/` app entry point and app reducer/view
  - `Counter/App/Reducer/` app reducer
  - `Counter/App/Views/` app-level views
  - `Counter/App/Tabs/` tab screens and previews
- `Counter/Features/Counter/` counter feature (Reducer/Views/Models)
- `Counter/Features/Settings/` settings feature (Reducer/Views)
- `Counter/Features/Appearance/` appearance feature (Reducer)
- `Counter/Dependencies/` shared dependencies (e.g., `FactClient`, `ThemeClient`)
- `Counter/Shared/` shared design tokens and UI components
- `Counter/Resources/` asset catalogs
- `CounterTests/` test suite

## Build & Run
Open `Counter.xcodeproj` in Xcode and run the `Counter` scheme.
