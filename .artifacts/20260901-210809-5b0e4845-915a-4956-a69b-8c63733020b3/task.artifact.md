# Task Management

- [x] Research Project and Free APIs
- [x] Propose Roadmap for DeepL/RapidAPI Integration
- [x] Step 1: External Setup & Core Service Implementation
    - [x] Register RapidAPI/Deep Translate
    - [x] Implement `TranslationService` (Deep Translate only)
    - [x] Create Riverpod provider
    - [x] Verify with automated tests
- [x] Step 2: Integration with Language Switcher (VN/EN)
    - [x] Sync `TranslationService` with `localeNotifierProvider`
    - [x] Create `TranslatedText` reusable widget
- [x] Step 3: Integration with Guides Feature
    - [x] Apply translation to Title, Description, and Tools in `GuideDetailScreen`
    - [x] Implement custom translation for Steps (preserving color codes)
- [x] Step 4: Performance & Caching
    - [x] Use Riverpod `translatedTextProvider` for session-level caching
    - [x] Implement logic to skip translation when source == target
