# Español Pro - Project Summary

**Status:** Completed MVP (v2.0)
**Date:** 2025-12-05

## 🔗 Key Links
*   **Backend API:** `https://espanol-pro-backend.xamide.workers.dev`
*   **GitHub Repo:** `https://github.com/LienCF/espanol-pro` (Assumed)

## 🛠️ Tech Stack
*   **Frontend:** Flutter (Mobile/Desktop), Riverpod, Drift, Dio.
*   **Backend:** Cloudflare Workers (Hono), D1 (SQL), R2 (Storage), Workers AI (Whisper/Llama).
*   **Language:** TypeScript (Backend), Dart (Frontend), Python (Content Pipeline).

## ✨ Key Features Implemented
1.  **Dual-Track Curriculum:** General (A1-C2) & Specialized (Medical, Construction).
2.  **AI Speech Evaluation:** Real-time pronunciation feedback using Levenshtein distance & Whisper.
3.  **AI Roleplay:** Chat with "Carlos" (Llama 3) with grammar correction.
4.  **Adaptive Learning:** Bayesian Knowledge Tracing (BKT) engine to track skill mastery.
5.  **Offline-First:** Drift database with request queueing for offline progress sync.
6.  **Desktop Optimized:** Adaptive layouts, window management, and keyboard shortcuts.
7.  **Infrastructure:** Presigned R2 uploads for performance and cost efficiency.

## 🚀 Quick Start

**Backend:**
```bash
cd backend
npx wrangler deploy
```

**Frontend:**
```bash
cd frontend
flutter run -d macos # or windows/linux/chrome
```

**Content:**
```bash
cd content_pipeline
python generate_audio.py
```

## 📝 Recent Changes
*   Implemented BKT algorithm and Skills Dashboard.
*   Switched to R2 Presigned URLs for audio uploads.
*   Added Levenshtein distance for accurate speech scoring.
*   Polished Desktop UI with adaptive layouts.
