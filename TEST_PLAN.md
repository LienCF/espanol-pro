# Español Pro - Integration Test Plan

## 1. Objective
To verify the end-to-end functionality of the application, ensuring critical user flows work as expected across supported platforms (Mobile/Desktop/Web).

## 2. Scope
This plan covers the following core user journeys:
1.  **Authentication:** Login, Logout (Simulated).
2.  **Dashboard:** Course listing, Skill visualization.
3.  **Learning:**
    *   Opening a Course -> Unit -> Lesson.
    *   Completing a Lesson (Dialogue/Drill).
    *   Progress persistence (UI update).
4.  **AI Features:**
    *   Speech Practice (Mocked audio input).
    *   AI Chat (Mocked response).
5.  **Offline/Sync:** (Manual verification mostly, but basic state check in tests).

## 3. Test Environment
*   **Framework:** `integration_test` (Flutter SDK).
*   **Runner:** `flutter test integration_test/app_test.dart`.
*   **Mocking:** We will mock the network layer (`Dio`) or use a mock server to avoid hitting production APIs during automated testing, or run against a local backend instance. For this plan, we will mock the `AuthRepository` and `CourseRepository` behaviors where possible or use the real `ProviderContainer` with overridden providers if we want to test UI logic specifically.
    *   *Decision:* We will use `ProviderScope(overrides: [...])` in the test entry point to inject Mock Repositories or use a "Test Mode" flag to simulate API responses.

## 4. Test Scenarios

### Scenario 1: User Login & Dashboard Load
*   **Given:** App starts in logged-out state.
*   **When:** User enters valid credentials and taps Login.
*   **Then:** App navigates to Dashboard. Course list is displayed.

### Scenario 2: Course Navigation & Lesson Completion
*   **Given:** User is on Dashboard.
*   **When:** User taps a Course -> Taps a Lesson.
*   **Then:** Lesson Player opens. Content is visible.
*   **When:** User completes the lesson activities.
*   **Then:** "Lesson Completed" snackbar appears. Progress is updated on return.

### Scenario 3: AI Speech Practice
*   **Given:** User is in Speech Practice mode.
*   **When:** User taps Record (simulated).
*   **Then:** Score result is displayed (Mocked high score).

## 5. Execution
Run the following command:
```bash
flutter test integration_test/app_test.dart
```
