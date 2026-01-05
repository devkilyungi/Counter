# Counter

A small SwiftUI counter app built with The Composable Architecture (TCA 1.23.1) and Swift 6.

## Features
- Increment/decrement counter
- Timer-driven auto-increment using `continuousClock`
- Cat fact fetch via an injected `FactClient`
- Tests written with Swift's `Testing` framework

## Structure
- `Counter/App/` app entry point
- `Counter/Features/Counter/` reducer, view, models
- `Counter/Dependencies/` shared dependencies (e.g., `FactClient`)
- `Counter/Resources/` asset catalogs
- `CounterTests/` test suite

## Build & Run
Open `Counter.xcodeproj` in Xcode and run the `Counter` scheme.
