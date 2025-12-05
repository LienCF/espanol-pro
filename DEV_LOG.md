# Español Pro - Development Log

## 0. Documentation Standards
**Important:**
*   **Development Log:** Maintain `DEV_LOG.md`, rigorously tracking every step and change.
*   **Accurate Timestamps:** All logs and documents must reflect the **actual current date (e.g., 2025-12-05)**, not simulated future dates.

## Phase 1: Infrastructure & MVP

### 2025-12-05
*   **Task:** Initial Project Setup
*   **Status:** Completed
*   **Details:**
    *   Created `GEMINI.md` as the single source of truth.
    *   Initialized Flutter project `frontend`.
    *   Initialized Cloudflare Workers project `backend`.
    *   Setup `content_pipeline` python environment.

### 2025-12-05 (Later)
*   **Task:** Backend Configuration
*   **Status:** Completed
*   **Details:**
    *   Configured `wrangler.toml` with D1 database ID.
    *   Created `schema.sql` with tables for `courses`, `units`, `lessons`, `users`, and `bkt_state`.

### 2025-12-05 (Later)
*   **Task:** Frontend Architecture Setup
*   **Status:** Completed
*   **Details:**
    *   Added dependencies: `flutter_riverpod`, `go_router`, `drift`, `freezed`, `google_fonts`.
    *   Implemented Clean Architecture structure.
    *   Implemented `AppTheme`.
    *   Implemented `DashboardScreen` (Placeholder).

### 2025-12-05 (Later)
*   **Task:** Data Layer Implementation
*   **Status:** Completed
*   **Details:**
    *   Defined Domain Models (`Course`, `Unit`, `Lesson`) using Freezed.
    *   Defined Drift Database Schema (`CoursesTable`, `UnitsTable`, `LessonsTable`).
    *   Ran `build_runner` to generate code.
    *   Fixed import path issue in `database_provider.dart`.
    *   Implemented `CourseRepository` with seeding logic (Mock Data).
    *   Added providers for fetching Course Detail and Units/Lessons.

### 2025-12-05 (Later)
*   **Task:** UI & Routing Implementation
*   **Status:** Completed
*   **Details:**
    *   Implemented `CourseDetailScreen` with Sliver layout.
    *   Updated `DashboardScreen` to link to detail page using `go_router`.
    *   Configured `/course/:id` route.

### 2025-12-05 (Later)
*   **Task:** Content Pipeline Setup
*   **Status:** In Progress
*   **Details:**
    *   Setup Python environment with `pypdf`, `pandas`.
    *   Created `main.py` to generate Mock JSON for FSI Unit 1.
    *   Successfully generated `fsi_unit_1.json`.

### 2025-12-05 (Later)
*   **Task:** Environment Troubleshooting
*   **Status:** In Progress
*   **Details:**
    *   Encountered `sqlite3` version mismatch in CocoaPods during `flutter run -d macos`.
    *   Action: Updating local CocoaPods repo (`pod repo update`) to resolve dependency errors.

### 2025-12-05 (Later)
*   **Task:** macOS Build & Runtime Fixes
*   **Status:** Completed
*   **Details:**
    *   Resolved `sqlite3` dependency issues by running `pod install` in `macos`.
    *   Fixed Dart compilation errors:
        *   Updated `Course`, `Unit`, `Lesson` to `abstract class` to support Freezed mixins correctly.
        *   Updated `CourseRepository` and `AppDatabase` providers to use generic `Ref` from `flutter_riverpod`.
        *   Regenerated code with `build_runner`.
    *   Fixed macOS Sandbox crash:
        *   Added `com.apple.security.network.client` entitlement to allow Google Fonts network requests.
    *   Successfully launched app on macOS.

### 2025-12-05 (Later)
*   **Task:** Feature Implementation - Lesson Player & Content
*   **Status:** Completed
*   **Details:**
    *   Restored `watchLessons` in `CourseRepository` and added `watchLesson` for single lesson retrieval.
    *   Created `LessonPlayerScreen` capable of rendering 'DIALOGUE' (with speakers) and 'DRILL' (substitution exercises) from JSON content.
    *   Updated `router.dart` with `/lesson/:lessonId` route.
    *   Updated `seedInitialData` in `CourseRepository` to include richer content for FSI Unit 1 and a new Specialized Track unit ("Construction Safety").

### 2025-12-05 (Later)
*   **Task:** Feature Implementation - Audio Playback
*   **Status:** Completed
*   **Details:**
    *   Added `just_audio` dependency and updated macOS pods.
    *   Refactored `_DialogueView` in `LessonPlayerScreen` to handle audio playback state.
    *   Implemented real audio playback using a placeholder remote URL (BabyElephantWalk.wav) to verify the pipeline.

### 2025-12-05 (Later)
*   **Task:** Feature Implementation - Quiz UI
*   **Status:** Completed
*   **Details:**
    *   Implemented `_QuizView` in `LessonPlayerScreen` with interactive multiple-choice logic (selection, feedback, score tracking).
    *   Updated `seedInitialData` to include a functional "Unit Quiz" with questions and options.

### 2025-12-05 (Later)
*   **Task:** Backend Integration - Cloudflare & Data Sync
*   **Status:** Completed
*   **Details:**
    *   **Backend:** Implemented Hono endpoints in `backend/src/index.ts` (`/api/courses`, `/api/courses/:id`, etc.) to serve data from D1.
    *   **Data Import:** Created `backend/scripts/seed_d1.sql` to mirror the frontend's seed data into the D1 database.
    *   **Frontend:**
        *   Created `ApiClient` with Dio.
        *   Updated `CourseRepository` to include `syncCourses()` method which fetches from API and upserts into local Drift DB.
        *   Updated `DashboardScreen` to trigger `syncCourses()` on init instead of `seedInitialData()`.
    *   **Verification:**
        *   Ran backend locally with `wrangler dev`.
        *   Seeded local D1 database.
        *   Verified frontend successfully connects to `http://127.0.0.1:8787` and syncs data (logs confirm successful API calls).

### 2025-12-05 (Later)
*   **Task:** Feature Implementation - Progress Tracking
*   **Status:** Completed
*   **Details:**
    *   **Backend:** Added `POST /api/progress` to record logs (`study_logs`) and upsert user progress (`user_course_progress`).
    *   **Backend:** Updated `/api/courses` and `/api/courses/:id` to return progress info (`completed_count`, `total_lessons` and `completedLessonIds`).
    *   **Frontend:**
        *   Updated `CourseRepository` with `saveLessonProgress` method.
        *   Updated `LessonPlayerScreen` to accept `courseId` and save progress on completion.
        *   Updated router to nested structure: `/course/:id/lesson/:lessonId`.
        *   **UI Visualization:** Updated `Lesson` domain model to include `isCompleted`. Updated `syncCourses` to sync completion status to local DB. Updated `_LessonTile` to show green checkmark for completed lessons.
        *   **Dashboard UI:** Updated `CourseCard` to show a progress bar (X / Y lessons completed).

### 2025-12-05 (Later)
*   **Task:** Feature Implementation - User Authentication (MVP)
*   **Status:** Completed
*   **Details:**
    *   **Backend:** Added `POST /api/auth/login` to create or retrieve users by email (passwordless for MVP).
    *   **Frontend:**
        *   Added `shared_preferences` for persistence.
        *   Created `User` model and `AuthRepository`.
        *   Built `LoginScreen` and added Route Guards (`redirect`) in `GoRouter`.
        *   Updated `CourseRepository` to use the dynamic `userId` from `AuthRepository`.

### 2025-12-05 (Later)
*   **Task:** Cloud Deployment
*   **Status:** Completed
*   **Details:**
    *   Initialized remote D1 database `espanol-pro-db`.
    *   Applied schema and seeded data to the remote D1 instance.
    *   Deployed Cloudflare Worker to `https://espanol-pro-backend.xamide.workers.dev`.
    *   Updated Frontend `ApiConstants.baseUrl` to point to the production Cloudflare URL.

### 2025-12-05 (Later)
*   **Task:** Polish - Logout & Audio Assets
*   **Status:** Completed
*   **Details:**
    *   **Logout:** Implemented Logout via `PopupMenuButton` in `DashboardScreen`, fully resetting state and redirecting to Login.
    *   **Audio:** Updated database seed script to use diverse public audio samples (BabyElephant, PinkPanther, etc.) to simulate different content lines.
    *   **Database Update:** Created and ran `backend/scripts/update_audio.sql` to patch the remote production database without re-seeding from scratch (avoiding unique constraint errors).

### 2025-12-05 (Later)
*   **Task:** Feature Implementation - Audio Recording
*   **Status:** Completed
*   **Details:**
    *   Added `record` and `permission_handler` dependencies.
    *   Configured macOS permissions (`Info.plist`, Entitlements) for microphone usage.
    *   Implemented `RecordingWidget` with recording, timer, and playback logic.
    *   Integrated `RecordingWidget` into `LessonPlayerScreen` under dialogue lines for pronunciation practice.
    *   Successfully built and launched app on macOS.

### 2025-12-05 (Later)
*   **Task:** Feature Implementation - AI Speech Evaluation
*   **Status:** Completed
*   **Details:**
    *   **Backend:** Implemented `POST /api/ai/evaluate-speech`. Uses `c.req.parseBody` to handle multipart file upload and `c.env.AI.run('@cf/openai/whisper', ...)` for transcription. Scoring is a simple word overlap algorithm for MVP.
    *   **Frontend:** Updated `RecordingWidget` to use `Dio` for multipart/form-data upload. It calls the evaluation API after recording stops and displays the returned score.
    *   **Integration:** Deployed updated backend to Cloudflare. App connects to live AI endpoint.

### 2025-12-05 (Later)
*   **Task:** Content - Unit 2 & Specialized Track
*   **Status:** Completed
*   **Details:**
    *   Created `content_pipeline/parse_fsi.py` to generate JSON content.
    *   Generated content for Unit 2 (Greetings & Introductions).
    *   Seeded production database with `seed_content_v2.sql`.

### 2025-12-05 (Later)
*   **Task:** Feature Implementation - AI Roleplay Chat
*   **Status:** Completed
*   **Details:**
    *   **Backend:** Implemented `POST /api/ai/chat` connecting to `@cf/meta/llama-3-8b-instruct`.
    *   **Database:** Seeded a `ROLEPLAY` lesson into Unit 2.
    *   **Frontend:** Implemented `_RoleplayView` in `LessonPlayerScreen`. Features a chat interface (bubbles) where users can type messages and receive AI responses based on a lesson-specific system prompt.

### 2025-12-05 (Later)
*   **Task:** Content - Audio Generation & Cloud Sync
*   **Status:** Completed
*   **Details:**
    *   Installed `edge-tts` (failed due to network), switched to `gTTS`.
    *   Created `generate_audio.py` to generate real Spanish MP3 files for Unit 1 and Unit 2.
    *   Created `upload_audio.py` to upload these assets to Cloudflare R2.
    *   Generated and executed `update_audio_v3.sql` to update the production D1 database with the new R2 public URLs.

### 2025-12-05 (Later)
*   **Task:** Offline Sync - Request Queue & Retry
*   **Status:** Completed
*   **Details:**
    *   **Queueing:** `saveLessonProgress` now catches network errors and inserts failed requests into `PendingRequestsTable` while still performing an optimistic local update.
    *   **Retry Logic:** Implemented `processPendingRequests` in `CourseRepository` to replay queued requests.
    *   **Trigger:** Hooked `processPendingRequests` into `DashboardScreen.initState`, so the app attempts to sync offline progress every time it launches or navigates to the dashboard.

### 2025-12-05 (Later)
*   **Task:** UI/UX Polish - Chat & Dashboard
*   **Status:** Completed
*   **Details:**
    *   **Components:** Created `ChatBubble` (styled message bubbles) and `TypingIndicator` (animated dots).
    *   **Chat UI:** Integrated these components into `_RoleplayView` for a modern messaging experience.
    *   **Dashboard:** Enhanced `CourseCard` with gradient backgrounds (varying by track type), shadows, and a cleaner layout with a customized progress bar.

### 2025-12-05 (Later)
*   **Task:** Monetization - Paywall & Pro Status
*   **Status:** Completed
*   **Details:**
    *   **Schema:** Added `is_premium` to backend `users` table. Updated `User` frontend model.
    *   **Paywall:** Created `PaywallScreen` with a beautiful marketing UI and mock purchase capability.
    *   **Repository:** Created `SubscriptionRepository` to handle "Upgrading" (mock) and updating app state.
    *   **UI Guard:** `DashboardScreen` now locks "Specialized" tracks for non-premium users, showing a lock icon and fade effect. Tapping locked courses opens the Paywall. "Go Pro" button added to AppBar.