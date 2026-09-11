# Translation Integration (Deep Translate via RapidAPI with MyMemory Fallback)

This plan outlines the implementation of an automated translation service for Fixit Vietnam using the **Deep Translate API** from RapidAPI, with a fallback to **MyMemory API**.

## Technical Details (from RapidAPI)
- **Endpoint:** `https://deep-translate1.p.rapidapi.com/language/translate/v2`
- **Host:** `deep-translate1.p.rapidapi.com`
- **Method:** POST
- **Payload:** `{"q": "text", "source": "en", "target": "vi"}`

## Proposed Changes

### Core Translation Service

#### [NEW] [translation_service.dart](file:///D:/Documents/MOBILEAPP/FLUTTER/FIXIT/lib/core/services/translation_service.dart)
- Implements `translateText(String text, {String sourceLang = 'en', String targetLang = 'vi'})`.
- **Primary:** Calls Deep Translate API.
- **Fallback:** Calls MyMemory API (`https://api.mymemory.translated.net/get`).
- Includes a 2-second timeout and logging for each attempt.

#### [NEW] [translation_provider.dart](file:///D:/Documents/MOBILEAPP/FLUTTER/FIXIT/lib/core/services/translation_provider.dart)
- Provides the `TranslationService` instance using Riverpod.

---

## Verification Plan
1. **Manual Test:** Run a small script within the app to translate "Hello World" and "How to fix a screen" to Vietnamese.
2. **Fallback Verification:** Temporarily modify the API Key to verify that MyMemory takes over correctly.
