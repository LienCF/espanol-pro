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

---

## 第二部分：跨平台客戶端開發規劃 (Flutter)

... (後文保持不變) ...