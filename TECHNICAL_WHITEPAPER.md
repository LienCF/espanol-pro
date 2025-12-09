# 綜合西班牙語學習平台架構重構與遷移技術白皮書：基於 Cloudflare Workers 與 Flutter 的全平台解決方案

## 執行摘要

本技術白皮書詳細闡述了將現有綜合西班牙語學習平台的後端基礎設施遷移至 Cloudflare Workers 無伺服器生態系統，並採用 Google Flutter 框架重構行動與桌面端應用程式的全面修訂規劃。

... (前文保持不變) ...

### 1.4 AI 賦能：Workers AI 深度整合

本平台的差異化競爭力在於 AI 輔助教學。Cloudflare Workers AI 提供了無伺服器推理能力，無需管理 GPU 伺服器即可調用開源模型。

#### 1.4.1 語音評測：Whisper Large V2 Spanish
針對口語練習，我們選用 `@cf/clu-ling/whisper-large-v2-spanish` 模型。
*   **模型選擇理由：** 該模型專為西班牙語微調，在標準測試集上取得了 0.0855 的超低詞錯誤率（WER），顯著優於通用 Whisper 模型。它能更準確地識別西班牙語的連讀、重音以及不同地區的方言。
*   **評分邏輯：** Worker 觸發 AI 對用戶上傳的 R2 音訊進行轉錄。將轉錄文本與標準文本進行比對，使用 Levenshtein Distance 算法計算相似度，並反饋給用戶作為發音準確度評分。

#### 1.4.2 智慧家教：Llama 3.1
為了提供 24/7 的語法問答與對話練習，整合 `@cf/meta/llama-3.1-8b-instruct` 模型。
*   **上下文管理：** 由於 LLM 是無狀態的，對話歷史將存儲於 D1 中。每次請求時，Worker 從 D1 拉取最近 10 條對話紀錄，連同 System Prompt（設定為：「你是一位有耐心、鼓勵性的西班牙語老師...」）一併發送給模型。

## 3. AI Services Specification (New)

To formalize the development of Phase 2 features, we define the following API specifications.

### 3.1 Speech Evaluation API

**Endpoint:** `POST /api/ai/evaluate-speech`

**Description:**
Uploads a user's recorded audio file, transcribes it using Whisper, compares it against a reference text, and returns a similarity score and feedback.

**Request Headers:**
*   `Content-Type`: `multipart/form-data`

**Request Body (FormData):**
1.  `audio` (File): The audio recording (Blob). Supported formats: `audio/webm`, `audio/mp3`, `audio/wav`. Max size: 2MB.
2.  `referenceText` (String): The correct Spanish text the user is attempting to speak.
3.  `userId` (String): The ID of the user (for logging/analytics).

**Process Flow:**
1.  **Validation:** Check if `audio` and `referenceText` exist. Validate file size.
2.  **ASR Inference:**
    *   Model: `@cf/openai/whisper` (or `@cf/clu-ling/whisper-large-v2-spanish` if available).
    *   Input: Audio bytes.
    *   Output: JSON with `text` field.
3.  **Scoring Algorithm:**
    *   Normalize both `transcription` and `referenceText` (lowercase, remove punctuation, remove accents/tildes optionally for loose matching, or keep them for strict matching).
    *   Calculate `Levenshtein Distance` (edit distance).
    *   Calculate `Similarity Score` = `1 - (Distance / MaxLength)`.
    *   Scale to 0-100.
4.  **Feedback Generation:**
    *   If Score > 90: "Excellent pronunciation!"
    *   If Score > 75: "Good job, try to articulate clearly."
    *   If Score < 75: "Let's try again. Focus on..." (Could use LLM for detailed feedback later).

**Response Body (JSON):**
```json
{
  "score": 85,
  "transcribedText": "Hola me llamo Carlos",
  "feedback": "Good effort! You said 'Carlos' clearly.",
  "isCorrect": true
}
```

**Error Responses:**
*   `400 Bad Request`: Missing audio or reference text.
*   `413 Payload Too Large`: Audio file > 2MB.
*   `500 Internal Server Error`: AI Inference failed.

### 3.2 AI Roleplay Chat API

**Endpoint:** `POST /api/ai/chat`

**Description:**
Facilitates a turn-based roleplay conversation with an AI tutor ("Carlos"). It persists conversation history in D1 and injects grammar corrections into the AI's response.

**Request Body (JSON):**
```json
{
  "message": "Hola, me llamo Juan.",
  "conversationId": "uuid-v4-optional", 
  "reset": false
}
```
*   `message` (String): The user's latest input.
*   `conversationId` (String, Optional): Identifier for the conversation session. If omitted or new, a new ID is generated.
*   `reset` (Boolean, Optional): If true, clears history for this `conversationId`.

**Process Flow:**
1.  **Context Retrieval:**
    *   If `conversationId` is provided, fetch last 10 messages from D1 (`chat_history` table).
    *   If `reset` is true, delete/archive old messages.
2.  **Prompt Engineering:**
    *   System Prompt: "You are Carlos, a friendly Spanish tutor from Mexico. You are roleplaying a scenario: {scenario}. Keep responses concise (under 50 words) and suitable for A2 level learners. IMPORTANT: If the user makes a grammatical error, reply naturally first, then append a correction at the very end in this specific format: `[CORRECTION: <Spanish correction> - <English explanation>]`."
    *   Append User Message.
3.  **Inference:**
    *   Model: `@cf/meta/llama-3.1-8b-instruct`.
    *   Input: `[System, User_1, AI_1, ..., User_N]`.
4.  **Persistence:**
    *   Save `User Message` to D1.
    *   Save `AI Response` to D1.
5.  **Response:** Return the AI's text and the `conversationId`.

**Response Body (JSON):**
```json
{
  "response": "¡Hola Juan! Mucho gusto. ¿De dónde eres? [CORRECTION: Hola, me llamo Juan - Correct, but 'Soy Juan' is more natural]",
  "conversationId": "123e4567-e89b-12d3-a456-426614174000"
}
```

### 3.3 BKT (Bayesian Knowledge Tracing) Engine

**Concept:**
BKT tracks the probability $P(L_n)$ that a user has mastered a skill (Knowledge Component, KC) at step $n$.

**Model Parameters:**
*   $P(L_0)$: Initial probability of knowing the skill (Prior). Default: 0.1
*   $P(T)$: Probability of learning the skill at each step (Transition). Default: 0.1
*   $P(S)$: Probability of slipping (knowing the skill but answering incorrectly). Default: 0.1
*   $P(G)$: Probability of guessing (not knowing the skill but answering correctly). Default: 0.2

**Update Rule (Posterior Calculation):**
Given the user's performance at step $n$ (Correct or Incorrect):

1.  **Calculate Posterior $P(L_n | \text{Observation})$:**
    *   If Correct:
        $$P(L_n | \text{Correct}) = \frac{P(L_{n-1}) \cdot (1 - P(S))}{P(L_{n-1}) \cdot (1 - P(S)) + (1 - P(L_{n-1})) \cdot P(G)}$$
    *   If Incorrect:
        $$P(L_n | \text{Incorrect}) = \frac{P(L_{n-1}) \cdot P(S)}{P(L_{n-1}) \cdot P(S) + (1 - P(L_{n-1})) \cdot (1 - P(G))}$$

2.  **Account for Learning (Transition):**
    $$P(L_n) = P(L_n | \text{Observation}) + (1 - P(L_n | \text{Observation})) \cdot P(T)$$

**API Endpoint:** `POST /api/learning/attempt`

**Description:**
Records a learning attempt for a specific lesson, identifies the associated Knowledge Component (KC), and updates the user's mastery probability using BKT.

**Request Body (JSON):**
```json
{
  "userId": "user_123",
  "lessonId": "lesson_456",
  "isCorrect": true
}
```

**Process Flow:**
1.  **Lookup:** Fetch `kc_id` for the given `lesson_id`. If none, skip BKT (return status `skipped`).
2.  **Fetch State:** Retrieve current $P(L_{n-1})$ from `user_kc_state` for (`user_id`, `kc_id`). If not found, use default $P(L_0)$.
3.  **Calculate:** Apply BKT update rule to compute $P(L_n)$.
4.  **Persist:** Upsert new $P(L_n)$ into `user_kc_state`. Log raw interaction to `study_logs`.
5.  **Return:** The new mastery level and delta.

**Response Body (JSON):**
```json
{
  "kcId": "kc_subjunctive_present",
  "previousMastery": 0.45,
  "newMastery": 0.52,
  "delta": 0.07
}
```

### 3.4 Gamification & Social Services (Phase 5)

**Overview:**
To increase retention, we introduce Streaks, XP, and Leaderboards.

#### 3.4.1 Streak Tracking
**Goal:** Encourage daily usage.
*   **Logic:** A "Streak" increments if the user completes at least one lesson (or AI interaction) on consecutive days (UTC).
*   **Storage:** `user_streaks` table in D1.
*   **Update Trigger:** Checked/Updated on every `/api/learning/attempt` or `/api/progress` call.

#### 3.4.2 Experience Points (XP)
**Goal:** Quantify effort.
*   **Scoring:**
    *   Lesson Completion: +10 XP
    *   Perfect Score (Quiz): +50 XP
    *   Daily Streak Bonus: +10 XP * Streak Days (Cap at 100)
*   **Storage:** `users.total_xp` (Denormalized) and `xp_logs` (Audit).

#### 3.4.3 Leaderboard API
**Endpoint:** `GET /api/leaderboard`
**Parameters:**
*   `type`: `global` (default) or `friends`.
*   `period`: `weekly` (default) or `all_time`.

**Response Body (JSON):**
```json
{
  "period": "weekly",
  "leaderboard": [
    { "rank": 1, "userId": "u1", "displayName": "Maria", "xp": 1500, "avatarUrl": "..." },
    { "rank": 2, "userId": "u2", "displayName": "John", "xp": 1200, "avatarUrl": "..." }
  ],
  "userRank": { "rank": 45, "xp": 300 }
}
```

### 3.5 Admin & Content Management (Phase 6.1)

**Goal:** Allow non-technical staff to manage course content without touching DB scripts.

#### 3.5.1 Admin API
**Endpoint:** `POST /api/admin/content`
*   **Action:** Create or Update Course/Unit/Lesson.
*   **Auth:** Requires `role: 'admin'` in JWT token.
*   **Body:** JSON payload matching the DB schema.

#### 3.5.2 Admin Dashboard (Web)
*   **Route:** `/admin`
*   **Features:**
    *   List Courses (CRUD).
    *   Lesson Editor: JSON editor for `content_json` with schema validation.
    *   User Management: View user stats, grant premium manually.

### 3.6 Analytics & Monitoring (Phase 6.2)

**Goal:** Track KPI metrics.

#### 3.6.1 Event Tracking
**Endpoint:** `POST /api/analytics/event`
*   **Body:** `{ "event": "lesson_start", "properties": { "lessonId": "..." } }`
*   **Storage:** R2 Log files (batched) or specialized Analytics Engine (if available). For MVP, store in `analytics_events` D1 table (TTL 30 days).

### 3.7 Mobile Release Configuration (Phase 6.3)

**Goal:** Prepare binaries for App Store & Play Store.

*   **Android:**
    *   Signing Config (`key.properties`).
    *   Permissions (`AndroidManifest.xml`): Internet, Microphone.
*   **iOS:**
    *   Capabilities: Background Audio (optional), Microphone Usage Description.
    *   Signing: Xcode managed profile.

### 3.8 Advanced AI Features (Phase 6.4)

#### 3.8.1 AI Lesson Generator
**Endpoint:** `POST /api/ai/generate-lesson`
*   **Input:** `{ "topic": "Ordering Coffee", "level": "A1" }`
*   **Process:**
    1.  Llama 3 generates a dialogue JSON.
    2.  (Optional) TTS generates audio for lines.
*   **Output:** `Lesson` object (JSON).

---

## 第二部分：跨平台客戶端開發規劃 (Flutter)

... (後文保持不變) ...