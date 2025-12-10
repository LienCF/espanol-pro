# Español Pro 🇪🇸

**An Edge-Native, AI-Powered Spanish Learning Ecosystem.**

Español Pro helps learners break through the "intermediate plateau" with a dual-track system: standard fluency paths and specialized professional training (Medical, Construction, Legal, Business, Tourism). Built on **Cloudflare's Global Edge** and **Flutter**, it delivers milliseconds latency, offline-first reliability, and advanced AI tutoring features.

---

## 🚀 Key Features

### 📚 Dual-Track Curriculum
*   **General Track (A0-C2):** From **Introductory Pronunciation** (Vowels, Trilled R) to **Advanced Debates** (AI Ethics, Climate Change). Based on FSI standards.
*   **Specialized Track (ESP):** Vertical modules for professionals:
    *   🏗️ **Construction:** OSHA Safety & Site commands.
    *   ⚖️ **Legal:** Courtroom terminology & Procedures.
    *   💼 **Business:** Negotiation & Office etiquette.
    *   ✈️ **Tourism:** Survival phrases & Problem solving.
    *   🏥 **Medical:** Pain assessment & Triage.

### 🤖 Advanced AI Tutoring
*   **Phonetic Analysis:** Record your voice and get specific feedback (e.g., "Watch your trilled 'rr'") powered by **Whisper** and a custom **G2P (Grapheme-to-Phoneme)** engine.
*   **AI Roleplay:** Chat with "Carlos", an AI tutor powered by **Llama 3**. Practice real-world scenarios with **Real-time Grammar Correction**.
*   **Adaptive Learning:** Built-in **Bayesian Knowledge Tracing (BKT)** engine that tracks mastery of specific skills (e.g., Subjunctive Mood, Accents) and adapts progress visualization.

### ⚡ Edge-Native Architecture
*   **Global Low Latency:** Backend logic runs on Cloudflare Workers, distributed close to users worldwide.
*   **Offline-First:** Complete offline support using **Drift (SQLite)**. Progress syncs automatically when back online via a request queue.
*   **Zero-Egress Audio:** High-quality neural audio assets (generated via **Edge-TTS**) hosted on **Cloudflare R2**.

### 📊 Analytics & Gamification
*   **Streaks:** Daily usage tracking with fire indicators.
*   **XP System:** Earn points for completing lessons and speaking exercises.
*   **Leaderboards:** Compete globally with other learners.
*   **Admin Panel:** Web-based CMS for managing courses and generating AI lessons.

### 📱 Cross-Platform
*   **Flutter:** Single codebase for iOS, Android, macOS, and Windows.
*   **Desktop Optimized:** Keyboard shortcuts (`ArrowRight` to advance), adaptive grid layouts, and window constraints.
*   **Mobile Ready:** Release configuration for Play Store and App Store.

---

## 🛠️ Tech Stack

### Frontend (Client)
*   **Framework:** Flutter (Dart) - Clean Architecture
*   **State Management:** Riverpod 2.0 (Code Generation)
*   **Local DB:** Drift (SQLite) with Offline Sync
*   **Networking:** Dio (with Firebase Auth & Caching)
*   **Routing:** GoRouter

### Backend (Cloudflare)
*   **Runtime:** Cloudflare Workers (Hono framework)
*   **Database:** Cloudflare D1 (SQLite at the Edge)
*   **Object Storage:** Cloudflare R2
*   **AI Inference:** Workers AI (@cf/openai/whisper, @cf/meta/llama-3-8b-instruct)
*   **Scoring Engine:** Levenshtein Distance + Rule-based Phonetic G2P
*   **Analytics:** Custom event tracking & aggregation endpoint

### Content Pipeline
*   **Language:** Python
*   **TTS:** Edge-TTS (Neural Speech Synthesis)
*   **Automation:** Custom parsers for FSI and OSHA PDF content

---

## 📂 Project Structure

```
/
├── backend/            # Cloudflare Workers API (Hono) & D1 Schema
├── frontend/           # Flutter Application (Clean Architecture)
├── content_pipeline/   # Python scripts for generating audio/JSON content
└── output/             # Generated assets ready for upload
```

---

## 🏁 Getting Started

### Prerequisites
*   **Flutter SDK** (Latest Stable)
*   **Node.js** (v18+) & `npm`
*   **Python** (3.9+)
*   **Cloudflare Account** (Paid plan recommended for AI features, though Free tier works for basic tests)

### 1. Backend Setup

1.  **Install Wrangler:**
    ```bash
    npm install -g wrangler
    ```
2.  **Login to Cloudflare:**
    ```bash
    wrangler login
    ```
3.  **Setup D1 Database:**
    ```bash
    cd backend
    wrangler d1 create espanol-pro-db
    # Update wrangler.toml with the new database_id
    ```
4.  **Apply Schema & Seed Data:**
    ```bash
    wrangler d1 execute espanol-pro-db --file=schema.sql --remote
    wrangler d1 execute espanol-pro-db --file=scripts/seed_d1.sql --remote
    wrangler d1 execute espanol-pro-db --file=scripts/seed_niche_content.sql --remote
    ```
5.  **Deploy Worker:**
    ```bash
    npm install
    npx wrangler deploy
    ```

### 2. Content Setup (Optional)

If you want to regenerate audio or add new lessons:

1.  **Setup Python Environment:**
    ```bash
    cd content_pipeline
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    ```
2.  **Generate Content & Audio:**
    ```bash
    python generate_niche_content.py # Generates SQL
    python generate_niche_audio.py   # Generates MP3s
    ```
3.  **Upload to R2:**
    *   Create an R2 bucket named `espanol-pro-content`.
    *   Configure `wrangler.toml` with the bucket binding.
    *   Use `python upload_audio.py` to upload generated files.

### 3. Frontend Setup

1.  **Install Dependencies:**
    ```bash
    cd frontend
    flutter pub get
    ```
2.  **Code Generation (Freezed/Drift):**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
3.  **Configure API URL:**
    *   Open `lib/src/core/api/api_constants.dart`.
    *   Update `baseUrl` with your deployed Worker URL (e.g., `https://espanol-pro-backend.YOUR_SUBDOMAIN.workers.dev`).
4.  **Run the App:**
    ```bash
    flutter run -d macos  # or android/ios/windows
    ```

---

## 🔮 Future Roadmap

*   **Payments:** Integrate RevenueCat for subscription management.
*   **Content Expansion:** Import EUR-Lex (Legal) and Sports commentary datasets.
*   **Community:** Social leaderboards and peer learning groups.

---

*Built with ❤️ by LienCF*
