# Español Pro - Project Documentation

## 0. Documentation Standards
**Important:**
*   **Development Log:** Maintain `DEV_LOG.md`, rigorously tracking every step and change.
*   **Accurate Timestamps:** All logs and documents must reflect the **actual current date (e.g., 2025-12-06)**.

## 0.1 Development Principles (Strict Enforcement)
We follow a rigorous engineering discipline to ensure quality and scalability.

### 1. Spec-Driven Development (SDD)
*   **Design Before Code:** Never write implementation code without a clear specification.
*   **API First:** Define REST API schemas (endpoints, inputs, outputs, error codes) in `TECHNICAL_WHITEPAPER.md` or dedicated spec files before implementation.
*   **Data Modeling:** Define DB schemas and JSON structures explicitly.

### 2. Test-Driven Development (TDD)
*   **Red-Green-Refactor:**
    1.  **Red:** Write a failing test based on the Spec.
    2.  **Green:** Write just enough code to pass the test.
    3.  **Refactor:** Optimize the code while keeping tests passing.
*   **Backend Testing:** Use `vitest` for Cloudflare Workers logic (Mock D1/AI).
*   **Frontend Testing:** Use `flutter_test` for Widgets and `mockito` for Repository/API logic.

## 1. Project Overview
**Español Pro** is a global, adaptive Spanish learning ecosystem leveraging edge computing.
*   **Dual-Track:** General Proficiency (A1-C2) & Specialized Tracks (ESP - Medical, Legal, etc.).
*   **Edge-Native:** Low latency, global distribution via Cloudflare.
*   **Bilingual:** Fully localized interface and content (English/Traditional Chinese).

## 2. Technical Specifications

### Backend (Cloudflare Ecosystem)
*   **Framework:** Hono (TypeScript).
*   **Database:** D1 (SQLite) for User Data & Content Metadata.
*   **Storage:** R2 for Audio Assets.
*   **AI:** Workers AI (Whisper for ASR, Llama 3 for Evaluation/Chat).
*   **Queue:** Cloudflare Queues for async write buffering.

### Frontend (Flutter Client)
*   **Architecture:** Clean Architecture (Riverpod 2.0 + GoRouter + Dio).
*   **Local DB:** Drift (SQLite) for offline caching and sync.
*   **Localization:** `flutter_localizations` (ARB based).

### Data Pipeline
*   **Source of Truth:** `content_pipeline/generate_niche_content.py`.
*   **Versioning:** Incremental integer versioning triggered by Python script updates.

## 3. Functional Requirements

### Core Learning Engine
*   **FR-01 Bayesian Knowledge Tracing (BKT):** (Pending) Real-time mastery tracking.
*   **FR-02 Speech Evaluation Lab:** (Next Priority)
    *   **Input:** User audio (Blob).
    *   **Process:** Whisper Transcribe -> Phoneme/Word matching -> Scoring.
    *   **Output:** Score (0-100) & Specific error feedback.

### Content Management
*   **FR-03 Content Pipeline:** (Completed) Python scripts to generate bilingual JSON, manage versions, and seed D1.

## 4. Development Roadmap

### Phase 1: Infrastructure & MVP (Completed ✅)
*   [x] Backend: Cloudflare Workers + Hono + D1 setup.
*   [x] Frontend: Flutter project + Riverpod + Drift.
*   [x] Content: Python pipeline for generating courses, units, lessons.
*   [x] Localization: Full EN/ZH support for UI and Content.
*   [x] UI/UX: Modern Reader View, localized Quizzes/Drills.
*   [x] Cleanup: Removal of legacy hardcoded data.

### Phase 2: AI Intelligence & Interaction (Completed ✅)
*   **Goal:** "Coach" capabilities - Listen, Evaluate, Speak.
*   **Step 1: AI Speech Scoring (SDD + TDD)**
    *   [x] Spec: Define `/api/ai/evaluate-speech` interface.
    *   [x] Test: Write backend tests for scoring logic.
    *   [x] Impl: Integrate Workers AI (Whisper).
    *   [x] Client: Record audio -> Upload -> Show Result.
*   **Step 2: AI Roleplay Chat**
    *   [x] Upgrade current mock Chat to real Llama 3 inference.
    *   [x] Verify Chat UI handles corrections.
*   **Step 3: BKT Algorithm**
    *   [x] Implement mastery probability tracking.

### Phase 3: Expansion & Monetization (In Progress 🚧)
*   **Goal:** Offline Download, Auth, Payments.
*   **Design:** See `DESIGN_OFFLINE_MODE.md` for architecture.
*   **Tasks:**
    *   [x] Offline Mode (DB Schema, AssetService, DownloadManager, UI Hook, Content Parsing).
    *   [x] Authentication (Firebase Scaffolding + Backend Verification Middleware).
    *   [x] Stripe Integration (Checkout Session API, Webhook, UI Launch).
    *   [x] End-to-End Testing (Full Flow Test).

## 5. Immediate Next Steps
1.  **Refactor & Cleanup:** Review codebase for hardcoded strings or messy logic before moving to Phase 3.
2.  **Phase 3 Preparation:** Design the "Offline Mode" architecture (downloading R2 assets to local file system).
3.  **UI Polish:** Improve the visual feedback for Speech Scoring (animations) and Chat (typing indicators).
