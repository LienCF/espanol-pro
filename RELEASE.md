# Release Preparation Guide

## 1. App Icons & Splash Screen
We use `flutter_launcher_icons` and `flutter_native_splash` to generate assets.

1.  Place your high-res app icon (1024x1024 PNG) at `frontend/assets/images/icon.png`.
2.  Place your splash screen logo (PNG) at `frontend/assets/images/splash.png`.
3.  Run:
    ```bash
    cd frontend
    dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
    dart run flutter_native_splash:create --path=flutter_launcher_icons.yaml
    ```

## 2. Store Metadata

### App Store (iOS/macOS)
*   **Name:** Español Pro
*   **Subtitle:** AI Spanish Tutor
*   **Keywords:** spanish, learning, tutor, ai, pronunciation, medical, construction, language
*   **Description:**
    > Master Spanish with Español Pro! Specialized tracks for Medical and Construction professionals. 
    > Features:
    > - AI Roleplay with "Carlos"
    > - Real-time Pronunciation Scoring
    > - Adaptive Learning (BKT)
    > - Offline Mode

### Play Store (Android)
*   **Title:** Español Pro: AI Spanish Tutor
*   **Short Description:** Learn Spanish with AI. Medical & Construction tracks included.
*   **Full Description:** [Same as above]

## 3. Screenshots Checklist
Capture the following screens on:
*   iPhone 6.5" (Max)
*   iPhone 5.5" (Plus)
*   iPad Pro (12.9")
*   Android Phone
*   Android Tablet

**Screens:**
1.  **Dashboard:** Show Progress & Skill Mastery.
2.  **Lesson Player:** Show a Dialogue or Drill.
3.  **AI Chat:** Show a conversation with correction (Yellow bubble).
4.  **Speech Practice:** Show a high score result.
5.  **Paywall:** Show the Pro features list.

## 4. Build Commands

**Android (App Bundle):**
```bash
flutter build appbundle
```

**iOS (Archive):**
```bash
flutter build ipa
```

**Web:**
```bash
flutter build web --release --wasm
```
