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

### 2025-12-05 (Later)
*   **Task:** AI Feature - Grammar Correction
*   **Status:** Completed
*   **Details:**
    *   **Backend:** Modified `POST /api/ai/chat` to inject a system instruction: "If the user makes a grammatical error... append a correction at the end in this format: [CORRECTION: ...]".
    *   **Frontend:** Updated `_RoleplayView` to parse the `[CORRECTION: ...]` tag from the AI response.
    *   **UI:** Updated `ChatBubble` to display corrections in a dedicated, styled box ("Lightbulb" style) below the main message.

### 2025-12-05 (Later)
*   **Task:** BKT Engine & Skills Visualization
*   **Status:** Completed
*   **Details:**
    *   **Schema:** Added `kc_id` to `lessons` table. Created `knowledge_components` and `user_kc_state` tables.
    *   **Logic:** Implemented Bayesian Knowledge Tracing algorithm (`calculateNewMastery`) in backend (`bkt.ts`).
    *   **API:** Updated `POST /api/progress` to calculate and update mastery. Added `GET /api/users/:userId/skills` to fetch mastery data.
    *   **Frontend:** Created `Skill` domain model and `SkillsRepository`. Added a "Skills" tab to `DashboardScreen` with `NavigationBar`, displaying skills as cards with circular progress indicators.

### 2025-12-05 (Later)
*   **Task:** Desktop Optimization & Polish
*   **Status:** Completed
*   **Details:**
    *   **Window Manager:** Added `window_manager` dependency. Configured `main.dart` to enforce minimum window size (800x600) and custom title for desktop builds.
    *   **Shortcuts:** Implemented keyboard navigation in `LessonPlayerScreen`. `ArrowRight` now triggers the "Next/Complete" action.
    *   **Adaptive Layout:** Refactored `DashboardScreen` to use `LayoutBuilder`. On screens wider than 600px, courses are displayed in a responsive `GridView` instead of a `ListView`.

### 2025-12-05 (Later)
*   **Task:** AI Feature - Advanced Speech Scoring
*   **Status:** Completed
*   **Details:**
    *   **Algorithm:** Implemented Levenshtein Distance algorithm in `backend/src/utils/scoring.ts` to calculate text similarity (0-100%).
    *   **Backend:** Updated `POST /api/ai/evaluate-speech` to use the new `calculateSimilarity` function instead of simple word overlap.
    *   **Deployment:** Deployed updated worker to production.

### 2025-12-05 (Later)
*   **Task:** Infrastructure - Presigned Uploads (R2)
*   **Status:** Completed
*   **Details:**
    *   **Backend:** Installed `@aws-sdk/client-s3`. Added `POST /api/upload/presign` to generate secure PUT URLs for R2.
    *   **Backend:** Updated `POST /api/ai/evaluate-speech` to accept `fileKey` and fetch audio directly from R2 bucket instead of requiring multipart upload.
    *   **Frontend:** Refactored `RecordingWidget` to first get a presigned URL, upload audio directly to R2 using `Dio.put`, and then trigger evaluation with the R2 key.

### 2025-12-05 (Later)
*   **Task:** Content - Niche Tracks (Construction, Legal, Nomad)
*   **Status:** Completed
*   **Details:**
    *   **Pipeline:** Created `content_pipeline/generate_niche_content.py` to programmatically generate SQL seeds for specialized courses.
    *   **Database:** Seeded D1 with "Spanish for Construction" (A2), "Legal Spanish 101" (B2), and "Digital Nomad Spain" (B1).
    *   **Frontend:** Implemented three new lesson views:
        *   `_FlashcardView`: Flip cards for vocabulary learning.
        *   `_ReadingView`: Text passage with comprehension questions.
        *   `_ImageQuizView`: Audio-prompted image selection grid.
    *   **Integration:** Verified all new content types render correctly in `LessonPlayerScreen`.

### 2025-12-05 (Later)
*   **Task:** AI Feature - Phonetic Analysis
*   **Status:** Completed
*   **Details:**
    *   **G2P:** Implemented a rule-based Spanish Grapheme-to-Phoneme converter in `backend/src/utils/g2p.ts`.
    *   **Scoring:** Enhanced `scoring.ts` with `analyzePronunciation` which compares standard IPA vs transcribed IPA to detect specific errors (e.g., trilled 'r' vs tap).
    *   **API:** Updated `evaluate-speech` to return a `feedback` list.
    *   **UI:** Updated `RecordingWidget` to show an info icon when feedback is available, opening a dialog with specific pronunciation tips.
