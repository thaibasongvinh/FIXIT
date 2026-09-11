# Implementation Plan - Project-Wide Translation Optimization

This plan outlines the steps to implement a robust, high-performance translation system for the entire FixIt project using Deep Translate with global batching and caching.

## Proposed Changes

### 1. Centralized Caching & Management
- **Local Database (Hive):** Implement a persistent cache for translations using Hive. This ensures that once a text is translated, it loads instantly in future sessions.
- **Translation Interceptor:** Create a centralized logic to intercept translation requests, check the cache first, and batch unsaved requests.

### 2. Global Batching Architecture
- **Automatic Screen Pre-fetching:** Create a Mixin or Base Widget that automatically scans the current screen for translatable strings and triggers a single batch request.
- **Provider Enhancement:** Update `translatedBatchProvider` to be more reactive and handle global app state (like language changes) efficiently.

### 3. Screen-by-Screen Integration (Phase 1: Core Screens)
Update the following priority screens to use the new batching/pre-fetching system:
- `LoginScreen`, `RegisterScreen`
- `HomeScreen`, `ProfileScreen`
- `AdminDashboardScreen` (High text density)
- `MyBookingsScreen`

### 4. UI Consistency Audit
- Ensure all `TextField` labels, `Hints`, `Dialogs`, and `Snackbars` use `TranslatedText` or a helper method that hooks into the new translation system.

---

## Technical Details

### [NEW] [translation_cache_service.dart](file:///D:/Documents/MOBILEAPP/FLUTTER/FIXIT/lib/core/services/translation_cache_service.dart)
- Handles Hive box initialization and CRUD for translations.

### [translation_service.dart](file:///D:/Documents/MOBILEAPP/FLUTTER/FIXIT/lib/core/services/translation_service.dart)
- Integrate with `TranslationCacheService`.
- Logic: `Get from Cache` -> `If missing, add to Batch Queue` -> `Execute Batch` -> `Save to Cache`.

---

## Verification Plan

### Automated Tests
- Extend `test/translation_test.dart` to cover caching logic.
- Verify that duplicate requests for the same string don't trigger multiple API calls.

### Manual Verification
- Navigate through all core screens in Japanese/Korean.
- Verify that after the first visit, all translations appear instantly.
- Use the Debug Console to monitor "Cache Hit" vs "API Request" logs.
