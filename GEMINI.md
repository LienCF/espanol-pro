# Español Pro - Project Documentation

## 0. Documentation Standards
**Important:**
*   **Development Log:** Maintain `DEV_LOG.md`, rigorously tracking every step and change.
*   **Accurate Timestamps:** All logs and documents must reflect the **actual current date (e.g., 2025-12-05)**, not simulated future dates.

## 1. Project Overview
**Español Pro** is a global, adaptive Spanish learning ecosystem leveraging edge computing architecture. It addresses the "intermediate plateau" and "generic fatigue" in language learning by offering a dual-track system:

*   **General Track (A1-C2):** A standardized path from zero to fluency based on FSI and UT Austin public resources.
*   **Specialized Track (ESP):** Vertical professional training for high-value fields (Construction, Medical, Legal, Digital Nomad) using authoritative texts (OSHA, EUR-Lex).

## 2. Technical Specifications (Edge-Native)

### Backend Infrastructure (Cloudflare Ecosystem)
*   **Compute:** Cloudflare Workers using the **Hono** framework (TypeScript) for REST APIs. Low cold start (<5ms), global distribution.
*   **Database:**
    *   **Content DB (D1):** Stores courses, vocabulary, quizzes. Read Replication enabled.
    *   **User DB (D1):** Stores user progress, BKT model parameters.
    *   **Write Buffer:** **Cloudflare Queues** to handle concurrent write limitations of D1; consumers batch write to DB.
*   **Storage:** **Cloudflare R2** for FSI audio slices and user recordings (Zero Egress Fee).
*   **AI Inference (Workers AI):**
    *   **Whisper:** Automatic Speech Recognition (ASR) for pronunciation evaluation.
    *   **Llama 3:** LLM for role-play dialogues and grammar correction.

### Frontend Application (Flutter Client)
*   **Framework:** **Flutter** (Dart) targeting Mobile (iOS/Android) and Desktop (Windows/macOS).
*   **Architecture:** **Clean Architecture** (Data, Domain, Presentation layers).
*   **State Management:** **Riverpod 2.0** (Async data flow & dependency injection).
*   **Offline Capability:** **Drift (SQLite)** or **Hive** for local caching/sync strategies.
*   **Desktop Polish:**
    *   `window_manager` for custom title bars/constraints.
    *   `Shortcuts` widget for keyboard navigation.
    *   Adaptive layouts (Single column mobile vs. Three-column desktop).

## 3. Functional Requirements

### Core Learning Engine
*   **FR-01 Bayesian Knowledge Tracing (BKT):** Real-time calculation of knowledge component (KC) mastery probability ($P(L_t)$) instead of simple SRS. Implemented in Workers (TypeScript).
*   **FR-02 Speech Evaluation Lab:**
    *   **Shadowing:** User records audio -> Upload to R2 -> Whisper Transcribe -> Phoneme-level accuracy comparison & speed analysis.
    *   **Feedback:** Visual waveform and color-coded error highlighting.

### Content Management
*   **FR-03 Content Pipeline:** Local **Python scripts** to parse PDF/HTML sources (FSI, OSHA), slice audio (ffmpeg), generate standard JSON, and upload to D1/R2.

## 4. Development Roadmap

### Phase 1: Infrastructure & MVP (Month 1-3)
*   **Goal:** Core architecture + "A1 General" & "Construction Safety" modules.
*   **Tasks:**
    *   [Backend] Init Cloudflare Workers + Hono.
    *   [Backend] Design D1 Schema (Users, Courses, Progress).
    *   [Backend] Setup R2 Buckets & Presigned URLs.
    *   [Frontend] Init Flutter project & Clean Architecture structure.
    *   [Frontend] Build basic UI (AudioPlayer, QuizLayout).
    *   [Content] Python parser for FSI Vol 1 (Units 1-5).
    *   [Content] Create OSHA Construction Safety image/text quizzes.

### Phase 2: Voice Interaction & BKT Engine (Month 4-6)
*   **Goal:** AI "Listen & Speak" features + Adaptive Algorithm.
*   **Tasks:**
    *   [AI] Integrate Workers AI (Whisper) for scoring.
    *   [AI] Integrate Llama 3 for Roleplay.
    *   [Frontend] Recording UI & Waveform Visualizer.
    *   [Backend] Implement BKT math model + Queue consumers.
    *   [Platform] Offline sync mechanism (Drift <-> D1).

### Phase 3: Expansion & Desktop Polish (Month 7-9)
*   **Goal:** Legal/Sports content, Desktop optimization, Monetization.
*   **Tasks:**
    *   [Content] Import EUR-Lex & SoccerNet materials.
    *   [Frontend] Desktop keyboard shortcuts & multi-window support.
    *   [Frontend] Large screen adaptive layouts.
    *   [Business] Stripe/RevenueCat integration.

## 5. Immediate Next Steps
1.  **Cloudflare Setup:** Register account, enable Workers Paid.
2.  **Project Initialization:** Create Flutter repository.
3.  **Content Prep:** Download FSI Spanish Basic Vol 1 assets and start writing the Python parser.