# Design Document: Offline Mode Architecture (Phase 3)

## Overview
Enables users to access course content (text, audio, images) without an active internet connection. This is critical for learners in areas with poor connectivity or commuters.

## Core Components

### 1. Local Database (Drift)
*   **Schema:** Already exists (`lessons` table has `content_json`).
*   **Status Tracking:** Add `download_status` column to `courses` or `units` table.
    *   `NOT_DOWNLOADED`, `DOWNLOADING`, `DOWNLOADED`, `FAILED`.
*   **Sync Strategy:**
    *   Metadata (Course structure) is always synced on app start (if online).
    *   Assets (Audio/Images) are downloaded on demand or via "Make Available Offline" toggle.

### 2. File System Storage
*   **Path:** `ApplicationDocumentsDirectory/offline_content/{courseId}/`.
*   **Structure:**
    *   `.../{courseId}/{unitId}/{lessonId}/audio.mp3`
    *   `.../{courseId}/{unitId}/{lessonId}/image.png`
*   **Mapping:** Use a local table `offline_assets` to map URL -> Local Path.
    *   `url` (PRIMARY KEY)
    *   `local_path`
    *   `file_size`
    *   `last_accessed`

### 3. Download Manager Service
*   **Responsibilities:**
    *   Queue downloads.
    *   Handle retries.
    *   Report progress (0-100%).
    *   Verify integrity (optional hash check).
*   **Implementation:**
    *   Use `dio` for downloading.
    *   Use `workmanager` (optional) for background downloads.

### 4. Asset Resolution Strategy (The "Proxy")
*   **Current:** Apps use `network` URLs directly.
*   **New:** `AssetService.resolve(url)`
    *   Check `offline_assets` table.
    *   If exists and file exists -> Return `File(local_path)`.
    *   If not -> Return `Network(url)`.

## Implementation Plan

### Step 1: Asset Registry Table
Create `offline_assets` table in Drift.

```sql
CREATE TABLE offline_assets (
    url TEXT NOT NULL PRIMARY KEY,
    local_path TEXT NOT NULL,
    downloaded_at INTEGER,
    file_size INTEGER
);
```

### Step 2: AssetService
Create a service that can download a file and register it.

```dart
class AssetService {
  Future<String> getAssetPath(String url) async {
    // Check DB
    // If offline, return local path
    // If online, return url (or cache it)
  }
  
  Future<void> downloadCourse(String courseId) async {
    // 1. Fetch all lessons in course
    // 2. Parse content_json to find all "audio" and "image" URLs
    // 3. Queue downloads
  }
}
```

### Step 3: UI Integration
*   Add "Download" icon to `CourseDetailScreen`.
*   Show progress bar.
*   Update `AudioPlayer` and `Image.network` calls to use `AssetService`.

## Edge Cases
*   **Storage Space:** Check available disk space before downloading.
*   **Stale Content:** If content version updates, invalidate local assets?
    *   Simple approach: `generate_niche_content.py` generates new URLs for new content (immutable assets).
*   **Partial Downloads:** Resume from where left off.

## Future Improvements
*   **P2P Sharing:** Allow nearby devices to share course packs (ambitious).
