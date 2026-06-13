# Message Intelligence Service

This folder contains a Kotlin-based Android application skeleton built to explore message ingestion, normalization, classification, and simulation.

## Project purpose

The app is designed as a learning platform for:

- Android architecture and module separation
- Jetpack Compose UI development
- Notification listener service architecture
- Accessibility service integration
- In-memory data processing and classification
- Local message simulation and manual input

## What was implemented

The app includes:

- `MainActivity` with a Compose-based dashboard
- `MainViewModel` for application state and message flow
- `MessageRepository` for sample messages, simulated SMS/notification creation, and manual entry
- `MessageProcessor` for simple classification, OTP extraction, and validation logic
- `MessageNotificationListener` skeleton service for Android notification events
- `UiInspectionAccessibilityService` skeleton service for accessibility event observation
- Compose UI components to filter categories, simulate events, and add manual messages

## Architecture

### Data layer

- `data/MessageData.kt` defines canonical data structures:
  - `MessageRecord`
  - `MessageSource`
  - `MessageCategory`
- `data/MessageRepository.kt` stores messages in memory and provides simulation and filtering operations
- `data/MessageProcessor.kt` contains normalization and classification logic

### Domain layer

- `MainViewModel` orchestrates data from the repository and exposes state flows for UI consumption
- The classification strategy is rule-based and modeled for learning rather than production

### Presentation layer

- `ui/MessageIntelligenceApp.kt` builds the main Compose UI
- Themes and typography are defined under `ui/theme`

### Platform integration

- `AndroidManifest.xml` declares the main activity and two service entry points
- `service/MessageNotificationListener.kt` is a NotificationListenerService stub
- `service/UiInspectionAccessibilityService.kt` is an AccessibilityService stub

## How to build

From the project root (`message-intelligence -service`):

```bash
gradle clean assembleDebug
```

If you have the Android SDK installed and configured, you can also run:

```bash
gradle installDebug
```

> If your environment does not have a Gradle wrapper, use a system-installed Gradle.

## Learning notes

This implementation is intentionally small and focused on education. Use it to explore:

- message data normalization and domain modeling
- Compose layout state management
- service lifecycle and permissions
- simple classification and entity extraction pipelines

The `Docs` folder is the canonical place for architecture details and project notes. Add new documentation files here as you grow the app.
